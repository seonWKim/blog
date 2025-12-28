---
title: "Physical Virtual Foundations - NUMA"
date: 2025-12-28 00:00:01 -0500
categories: infra
tags: [infra, NUMA, core, socket]
---

As a software engineer, I often forget the importance of getting used to the hardware systems that software runs on.
As I'm diving into the hardware world, I found myself unfamiliar with hardware-related terms, so I would like to
start by defining these unfamiliar hardware terms. For today, I would like to start with NUMA architecture.

## NUMA (Non-Uniform Memory Access)

NUMA is a computer memory architecture where memory access time depends on the memory's location relative to the processor.

In NUMA, CPUs have their own local memory. But they can also access other CPUs' local memories. So the access time
depends on the distance between memory and CPU, hence called non-uniform memory access. This was introduced to solve
the scalability problem. If CPUs were to share a single memory, they could become the bottleneck. NUMA allows
systems to scale by having each CPU have its own memory.

### Why should software engineers care?

For software engineers like us, we love and need to think from the perspective of software performance. When we run our
software on NUMA systems, we have to consider CPU memory locality because allowing the CPU to access its local memory
is 2-10x faster than remote memory access. By writing your system NUMA-aware, it's now possible to enhance the system
performance. If you're developing an I/O-bound application, NUMA considerations may be less critical, but for performance-critical software such as databases or servers, NUMA is essential knowledge.

Key considerations for NUMA-aware programming:

- Pin threads to specific NUMA nodes for consistent performance
- Use NUMA-aware allocators like `tcmalloc` or `jemalloc`
- Apply NUMA topology in thread pool design
- For databases: configure buffer pools per NUMA node to optimize memory access patterns

### Wait, CPU = NUMA Node?

When I first learned about NUMA, I was confused about the terminology. Is CPU the same as NUMA node? Short answer: **No**.

#### The Hardware Hierarchy

Here's how things stack up in a typical server:

```
Server
├── NUMA Node 0 (Socket 0) ← Physical processor package
│   ├── Core 0 (CPU 0)
│   │   ├── Thread 0   ← Logical processor
│   │   └── Thread 1   ← With hyperthreading
│   ├── Core 1 (CPU 1)
│   │   ├── Thread 2
│   │   └── Thread 3
│   ├── ... (more cores, can have 8-64+ cores)
│   └── Local Memory (e.g., 64GB) ← Fast access for cores in this socket
│
└── NUMA Node 1 (Socket 1)
    ├── Core 8 (CPU 8)
    │   ├── Thread 16
    │   └── Thread 17
    ├── Core 9 (CPU 9)
    │   ├── Thread 18
    │   └── Thread 19
    ├── ... (more cores)
    └── Local Memory (e.g., 64GB)
```

So the relationship is:

- NUMA Node = Socket = Physical processor package on the motherboard
- Core/CPU = Individual processing unit (many per socket, like 8-64+)
- Thread = Logical processor (1-2 per core with hyperthreading)

#### Real Example: Dual-Socket Server

When you run `numactl --hardware` on a dual-socket server:

```bash
$ numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 16 17 18 19 20 21 22 23
node 0 size: 65536 MB
node 1 cpus: 8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31
node 1 size: 65536 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10
```

What this tells us:

- 2 NUMA nodes (2 physical sockets/packages)
- 16 physical cores per socket (CPUs 0-7 and 8-15)
- 32 hardware threads total (with hyperthreading: 16-23 and 24-31 are virtual)
- Memory distance: local=10, remote=21 (remote access is 2.1x slower!)

#### Visual: Memory Access Patterns

Where your thread runs and where your data lives matters a lot.

```
┌─────────────────────────────────────────┐
│      NUMA Node 0 (Socket 0)             │
│  ┌────┐ ┌────┐ ┌────┐       ┌────┐      │
│  │Core│ │Core│ │Core│  ...  │Core│      │
│  │ 0  │ │ 1  │ │ 2  │       │ 7  │      │
│  └────┘ └────┘ └────┘       └────┘      │
│  [====== Local Memory 64GB ======]      │
│         ↓ Fast (100ns)                  │
└─────────────────────────────────────────┘
                  ↕
        Slow interconnect (QPI/UPI)
              150-200ns latency
                  ↕
┌─────────────────────────────────────────┐
│      NUMA Node 1 (Socket 1)             │
│  ┌────┐ ┌────┐ ┌────┐       ┌────┐      │
│  │Core│ │Core│ │Core│  ...  │Core│      │
│  │ 8  │ │ 9  │ │ 10 │       │ 15 │      │
│  └────┘ └────┘ └────┘       └────┘      │
│  [====== Local Memory 64GB ======]      │
└─────────────────────────────────────────┘
```

