---
title: "Determinism in League of Legends Game Servers"
date: 2025-12-30 00:00:01 -0500
categories: programming
tags: [ determinism, game-servers, event-sourcing, testing ]
---

I recently learned about Riot's "Project Chronobreak" - a system that rewinds live League of Legends games to any point
in time. The concept of **determinism** caught my attention, especially since I've been contributing to Turso, a
database that uses deterministic simulation testing to catch bugs.

## What is Determinism?

Determinism is a property where **given the same inputs, a system produces the same outputs every time**. In the context
of League of Legends servers, this means that if you replay the exact same sequence of player inputs, network packets,
and game settings, you get the exact same game state at any point in time.

The opposite of determinism is **divergence** - when software fails to behave consistently. Because most computer
software is designed to be free of divergences, software divergences are typically the product of unexpected or
uncontrolled inputs.

### Why should software engineers care?

For most application developers, determinism isn't something we think about daily. But when you need to:

- **Replay and debug production issues** - reproduce exact conditions that led to a bug
- **Test complex distributed systems** - verify behavior under specific scenarios
- **Provide audit trails** - guarantee that replaying events produces identical state
- **Recover from failures** - restore to a known-good state

Then determinism becomes essential. League of Legends uses determinism for all of these: replaying matches, testing new
features, finding bugs, and most impressively, rewinding live esports matches when technical issues occur.

## How Riot Games Built Deterministic Game Servers

What impressed me most about Riot's implementation wasn't just that they achieved determinism, but **how they thought
through the problem**. Their approach offers lessons for any software engineer dealing with state management.

### Step 1: Identify the Source of Divergence

Riot's team realized that divergence doesn't come from software itself (software is mostly deterministic), but from
inputs. The challenge was figuring out which inputs mattered.

They classified inputs into two categories:

**Controlled inputs** - inputs that never change between executions:

- Game scripts and logic
- Hardware platform specifications
- Operating system behavior
- etc

**Uncontrolled inputs** - inputs that are noisy, random, or player-generated:

- Frame timing variations
- Client network traffic
- Random number generators
- Player actions
- etc

The insight here is: you don't need to make your entire system deterministic, just control the inputs that
matter

### Step 2: Simplify with a Core Rule

Rather than trying to make everything deterministic, Riot established one critical design decision:

> **SNRs (Server Network Recordings) would record and play back the state of the game a single frame at a time.**

This reminds me of Unix's "everything is a file" philosophy - a simple, well-defined rule that dramatically simplifies
system design. By establishing the frame as the fundamental unit:

- Network inputs are recorded in order of receipt each frame
- Game state is deterministic within frame boundaries
- Replay can jump to any frame and restore exact state

### Step 3: Implementation

With the rule established, implementation focused on controlling those uncontrolled inputs: unified game clocks,
recorded network inputs in order of receipt, and deterministic random number generation. The result is a frame-based
architecture where each frame captures inputs, computes game state, and records everything for replay.

## Connections to Familiar Patterns

As I learned about determinism in game servers, I noticed similarities to patterns we use in application development:

- **Functional programming:** Same input, same output. Pure functions are deterministic.
- **Event sourcing:** Replaying events to rebuild state, just like SNRs replay frames.

The parallels are clear:

- Deterministic code is easier to test
- Avoiding side effects prevents divergence
- Maintaining complete event history enables both replay and audit trails

Essentially, Riot built event sourcing with frames as the event boundary - each frame is an immutable record of inputs
and resulting state.

## Final Thoughts

What started as curiosity about game server technology turned into an appreciation for determinism as a design
principle. While I initially thought this was specific to gaming, the core concepts apply broadly:

- Application state management when you need strict guarantees about state transitions
- Debugging production issues by replaying events to reproduce bugs
- Compliance scenarios where you need to prove operations are reproducible

The key insight from Riot's implementation is that you don't need to make everything deterministic - you need to
identify and control the inputs that affect state. Whether you call it determinism, event sourcing, or something else,
the pattern of recording inputs and replaying state is a useful tool for building reliable systems. Next time you're
designing a system that needs strong consistency guarantees or replay capabilities, consider: what are your "frames,"
and what inputs do you need to control?

---

## References

- [Determinism in League of Legends: Introduction](https://technology.riotgames.com/news/determinism-league-legends-introduction)
