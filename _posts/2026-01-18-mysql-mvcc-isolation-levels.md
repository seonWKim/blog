---
layout: post
title: "MySQL MVCC and Isolation Levels - Under the Hood"
date: 2026-01-18
categories: [ programming ]
tags: [ mysql, mvcc, database, isolation-levels, innodb ]
---

I've used MySQL for years without really understanding how it handles concurrent transactions. I was curious what was
happening under the hood to provide consistent reads for the transactions. This post explains how InnoDB implements
MVCC and how it affects MySQL's isolation levels.

## What is MVCC?

Before MVCC, databases had a brutal choice: readers block writers and writers block readers(pessimistic locking), or
you accept dirty reads. MVCC introduces a third path—**versioned reality**. Each transaction sees a consistent snapshot
of data as it existed at a specific point in time, while other transactions continue modifying the "current" reality.

InnoDB implements MVCC by keeping old versions of rows in the **undo log**. When you update a row, InnoDB doesn't
overwrite it—it creates a new version and chains the old one into the undo log:

```
Current Row → Undo Record (v3) → Undo Record (v2) → Undo Record (v1)
```

This chain is called the **version chain** or **history list**.

## Why Should Software Engineers Care?

Every long-running transaction holds a reference to a point in time, preventing InnoDB from purging undo records older
than that point. A single `SELECT` that runs for 4 hours can prevent purging of 4 hours worth of undo history—across the
entire database, not just the tables it touches.

This means:

- **SELECT affects write performance.** Long SELECTs hold read views that prevent purge. As undo chains grow, every
  query must traverse longer chains.
- **Transaction duration ≠ query duration.** A transaction that opens, does a fast SELECT, makes HTTP calls, then
  commits later holds a read view the entire time.
- **Read replicas don't provide isolation.** Each replica maintains its own undo log. Long-running reads on replicas
  cause the same problems.

## How InnoDB Determines Visibility

When a transaction starts (or issues its first read in READ COMMITTED), InnoDB creates a **read view**—a snapshot of
which transactions were active at that moment. The read view tracks:

- `m_low_limit_id`: Transaction IDs >= this are invisible
- `m_up_limit_id`: Transaction IDs < this are visible (if committed)
- `m_ids`: List of active (uncommitted) transaction IDs

```
Timeline: trx_id  10    20    30    40    50    60
                   |     |     |     |     |     |
                   ✓     ✓     ?     ?     ✗     ✗
                         ↑           ↑           ↑
                   m_up_limit_id   m_ids    m_low_limit_id
                   (visible if    (active,  (invisible,
                    committed)    check     too new)
                                  m_ids)

Read View created at trx_id 50:
  - m_up_limit_id = 20 (oldest active trx when view created)
  - m_low_limit_id = 60 (next trx_id to be assigned)
  - m_ids = [30, 40] (active/uncommitted transactions)
```

Each row has a hidden `DB_TRX_ID` column storing the transaction that last modified it. To check visibility, InnoDB
compares this against the read view. If the version is too new or uncommitted, it walks the undo chain to find a visible
version.

## MySQL's REPEATABLE READ Has a Surprising Behavior

MySQL's REPEATABLE READ provides consistent reads, but **writes use "current read"** (the latest committed data). Your
UPDATE can modify a row that your SELECT in the same transaction wouldn't see.

From the [MySQL documentation on Consistent Nonlocking Reads](https://dev.mysql.com/doc/refman/8.0/en/innodb-consistent-read.html):

> A non-locking SELECT statement presents the state of the database from a read view... while the locking statements use
> the most recent state of the database to use locking. In general, these two different table states are inconsistent
> with each other.

In other words, InnoDB has two types of reads:
- **Consistent read** (plain SELECT): Reads from the snapshot established at transaction start
- **Locking read** (UPDATE, DELETE, SELECT FOR UPDATE): Reads the latest committed data

You can try this yourself:

```sql
-- Setup
CREATE TABLE accounts (id INT PRIMARY KEY, balance INT);
INSERT INTO accounts VALUES (1, 100);

-- Session A (REPEATABLE READ)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SELECT balance FROM accounts WHERE id = 1;
-- sees 100

-- Session B (in another terminal):
-- UPDATE accounts SET balance = 150 WHERE id = 1; COMMIT;

-- Back to Session A:
SELECT balance FROM accounts WHERE id = 1; -- still sees 100 (expected)
UPDATE accounts SET balance = balance + 10 WHERE id = 1;
SELECT balance FROM accounts WHERE id = 1; -- sees 160, not 110!
COMMIT;
```

The UPDATE operated on the current value (150), not the snapshot value (100). This behavior is specific to MySQL's
implementation of REPEATABLE READ.

## The Purge Thread is Your Silent Dependency

InnoDB runs background **purge threads** that clean up undo records no longer needed by any active read view. If purge
falls behind:

1. Undo tablespace grows
2. Longer undo chains mean more work to find visible versions
3. Queries slow down progressively

The problem: there's no automatic backpressure. MySQL doesn't abort long-running transactions or slow new writes when
undo grows dangerously. You find out when disk fills up or queries become slow.

## Common Failure Pattern: History List Explosion

Imagine this scenario: a reporting query or a forgotten `mysql` CLI session holds a transaction open for hours. The
history list length (visible in `SHOW ENGINE INNODB STATUS`) grows from thousands to millions. Query latency degrades
gradually, then suddenly.

What makes this failure mode tricky is that standard metrics look healthy:

- CPU utilization normal
- Connection count fine
- Buffer pool hit ratio high
- Query rate stable

The typical misdiagnosis: "Database is slow, need more memory/CPU." Engineers add indexes, increase buffer pool—none of
which help because the root cause is one old transaction holding a read view.

## What to Monitor

**History list length**: `SHOW ENGINE INNODB STATUS` shows this. Alert when it exceeds baseline by 10x.

**Transaction age**: Query `information_schema.innodb_trx` for transactions older than 60 seconds. The slow query log
won't catch these—it tracks query duration, not transaction duration.

**Undo tablespace size**: This can grow and never shrink (depending on configuration). You might carry hundreds of GB of
empty-but-allocated space after an incident.

## Final Thoughts

The key insight from exploring MVCC is that reads and writes are more interdependent than they appear. A long-running
SELECT isn't "just a read"—it holds a read view that affects the entire database's ability to clean up old versions.

When debugging "low CPU, slow database" situations, check:

1. History list length in `SHOW ENGINE INNODB STATUS`
2. Long-running transactions in `information_schema.innodb_trx`
3. Idle-in-transaction connections (queries finished fast but transaction uncommitted)

The answer is usually: find the incomplete work and finish it.

## Appendix: InnoDB Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              InnoDB Engine                                  │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         Buffer Pool (Memory)                        │    │
│  │                                                                     │    │
│  │   ┌──────────────┐      ┌──────────────┐      ┌──────────────┐      │    │
│  │   │   Data Page  │      │   Data Page  │      │  Undo Page   │      │    │
│  │   │  ┌────────┐  │      │  ┌────────┐  │      │              │      │    │
│  │   │  │  Row   │──┼──────┼──│ DB_TRX │  │      │  Old row     │      │    │
│  │   │  │        │  │      │  │  _ID   │  │      │  versions    │      │    │
│  │   │  └────────┘  │      │  │DB_ROLL │──┼──────│─────────────►│      │    │
│  │   │              │      │  │  _PTR  │  │      │              │      │    │
│  │   └──────────────┘      │  └────────┘  │      └──────────────┘      │    │
│  │                         └──────────────┘                            │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│         │                         │                      │                  │
│         │ flush                   │                      │                  │
│         ▼                         │                      │                  │
│  ┌──────────────┐                 │               ┌──────────────┐          │
│  │  Tablespace  │                 │               │   Undo Log   │          │
│  │   (.ibd)     │                 │               │  Tablespace  │          │
│  │              │                 │               │              │          │
│  │  Data file   │                 │               │ Version      │          │
│  │  on disk     │                 │               │ chains for   │          │
│  └──────────────┘                 │               │ MVCC         │          │
│                                   │               └──────────────┘          │
│                                   │                      ▲                  │
│                                   │                      │                  │
│  ┌────────────────────────────────┼──────────────────────┼──────────────┐   │
│  │                          Transaction                  │              │   │
│  │  ┌──────────────┐        ┌──────────────┐        ┌────┴───────┐      │   │
│  │  │  Read View   │        │    Locks     │        │  Undo Ptr  │      │   │
│  │  │              │        │              │        │            │      │   │
│  │  │ m_up_limit   │        │ Row locks    │        │ Points to  │      │   │
│  │  │ m_low_limit  │        │ Gap locks    │        │ rollback   │      │   │
│  │  │ m_ids[]      │        │ (REPEATABLE  │        │ segment    │      │   │
│  │  │              │        │  READ only)  │        │            │      │   │
│  │  │ Determines   │        │              │        │            │      │   │
│  │  │ visibility   │        │ Acquired by  │        │            │      │   │
│  │  │ for SELECT   │        │ writes and   │        │            │      │   │
│  │  │              │        │ SELECT FOR   │        │            │      │   │
│  │  │              │        │ UPDATE       │        │            │      │   │
│  │  └──────────────┘        └──────────────┘        └────────────┘      │   │
│  └──────────────────────────────────────────────────────────────────────┘   │
│                                   │                                         │
│                                   │ write-ahead                             │
│                                   ▼                                         │
│                          ┌──────────────┐                                   │
│                          │  Redo Log    │                                   │
│                          │  (WAL)       │                                   │
│                          │              │                                   │
│                          │ For crash    │                                   │
│                          │ recovery &   │                                   │
│                          │ durability   │                                   │
│                          └──────────────┘                                   │
└─────────────────────────────────────────────────────────────────────────────┘

Key relationships:
• Row → Undo Log: DB_ROLL_PTR links to previous versions for MVCC
• Read View → Undo Log: Determines which versions are visible to a transaction
• Transaction → Redo Log: All changes logged before commit (write-ahead logging)
• Locks: Prevent concurrent modifications, not used for plain SELECT (MVCC handles it)
```