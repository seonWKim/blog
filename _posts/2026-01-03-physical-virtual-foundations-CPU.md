---
layout: post
title: "Physical Virtual Foundations - CPU"
date: 2026-01-03
categories: [ infrastructure ]
tags: [ cpu, virtualization, containers, performance, numa, kubernetes ]
---

As I'm continuing to explore infrastructure concepts, I found myself confused by the term "CPU" appearing in different
contexts—physical CPUs, CPU cores, hyperthreads, vCPUs, CPU requests in Kubernetes. They all use "CPU" but mean
different things. I wanted to understand what "CPU" actually refers to at each layer: physical hardware, virtual
machines, and containers.

## The Hierarchy

Between your application and the physical core are multiple layers where things can queue or throttle:

```
Application Thread
   ↓  OS Scheduler
   ↓  [Container throttling]
   ↓  Hardware Thread
   ↓  [Hypervisor queue]
   ↓  Physical Core (executes instructions)
```

Standard CPU metrics only show the top layer.

## The Physical Layer

Modern servers have a hierarchy:

```
┌──────────────────────────────────────────────────────────────────┐
│                    MOTHERBOARD (NUMA Architecture)               │
│                                                                  │
│  ┌────────────────────────┐  ┌────────────────────────┐          │
│  │  CPU Socket 0          │  │  CPU Socket 1          │          │
│  │  ┌──────────────────┐  │  │  ┌──────────────────┐  │          │
│  │  │ L3 Cache (shared)│  │  │  │ L3 Cache (shared)│  │          │
│  │  └──────────────────┘  │  │  └──────────────────┘  │          │
│  │                        │  │                        │          │
│  │  ┌────────┐ ┌────────┐ │  │  ┌────────┐ ┌────────┐ │          │
│  │  │ Core 0 │ │ Core 1 │ │  │  │ Core 2 │ │ Core 3 │ │          │
│  │  │ L1  L2 │ │ L1  L2 │ │  │  │ L1  L2 │ │ L1  L2 │ │          │
│  │  │  ↓     │ │  ↓     │ │  │  │  ↓     │ │  ↓     │ │          │
│  │  │ HW T 0 │ │ HW T 2 │ │  │  │ HW T 4 │ │ HW T 6 │ │          │
│  │  │ HW T 1*│ │ HW T 3*│ │  │  │ HW T 5*│ │ HW T 7*│ │          │
│  │  └────────┘ └────────┘ │  │  └────────┘ └────────┘ │          │
│  │         ↑              │  │         ↑              │          │
│  └─────────┼──────────────┘  └─────────┼──────────────┘          │
│            │                           │                         │
│  ┌─────────┴────────────┐  ┌───────────┴──────────┐              │
│  │  Local Memory (fast) │  │  Local Memory (fast) │              │
│  └──────────────────────┘  └──────────────────────┘              │
│            ↕                           ↕                         │
│  ┌─────────────────────────────────────────────────┐             │
│  │  Cross-socket access (slow, crosses QPI/UPI)    │             │
│  └─────────────────────────────────────────────────┘             │
└──────────────────────────────────────────────────────────────────┘

* HW T 1, 3, 5, 7 only exist if hyperthreading is enabled
```

**Components**:

- **Socket**: Physical chip on motherboard
- **Core**: Execution unit with ALU (integer math) and FPU (floating-point math). Only thing that runs instructions.
- **L1/L2 Cache**: Per-core (32-64KB, 256KB-1MB)
- **L3 Cache**: Shared by all cores in socket (8-30MB)
- **Hardware Thread**: What OS schedules onto (1 per core, or 2 with hyperthreading)
- **NUMA**: Each socket has local memory

Example: Dual-socket server with 4 cores per socket and hyperthreading = 2 × 4 × 2 = **16 "CPUs"** to OS, but only **8
cores** execute instructions.

### Hyperthreading Doesn't Double Performance

**No.** Two hardware threads on the same core share ALU, FPU, L1/L2 caches, and memory bandwidth. Each gets its own
registers and program counter.

- **Best case**: Thread A uses ALU while Thread B uses FPU → parallel execution → 1.3-1.5x boost
- **Worst case**: Both use the same execution unit → each gets 50% throughput

Common mistake: Seeing "64 CPUs" in `/proc/cpuinfo` and creating 64 threads. Performance tanks because half are siblings
fighting for execution units.

## The Virtualization Layer

**pCPU**: Hardware thread on a real core. The actual execution resource.

**vCPU**: Software promise that hypervisor schedules onto pCPU. Guest OS doesn't know if it's a dedicated core,
hyperthread, or overcommitted (5+ vCPUs per pCPU).

**Steal time**: % of time vCPU wanted to run but waited in hypervisor queue. Visible as `%st` in `top`.

Your VM might show 40% CPU usage while being slow because vCPUs wait in the hypervisor queue. Guest OS sees idle CPU,
but vCPUs are queued for physical CPUs. You're measuring the wrong layer.

## The Container Layer: Hard Limits, Not Soft

Kubernetes CPU limits are not soft constraints—they're hard ceilings enforced by the kernel.

**CPU Request**: What Kubernetes uses for scheduling. Guarantees the node has this capacity.

**CPU Limit**: A hard ceiling enforced by Linux cgroups using **tumbling windows**.

### Tumbling Windows

CPU limits use fixed 100ms periods. No carryover, no borrowing. Example with 500m limit (50ms/100ms):

- Request needs 60ms CPU
- Period 1: Uses 50ms, FROZEN for 50ms
- Period 2: Completes in 10ms
- Result: 110ms latency for 60ms of work

Bursty workloads waste quota. A pattern of 10ms work every 200ms (5% average) still gets throttled because it exhausts
quota early in the period. Containers can show 40% CPU usage while throttling 30% of periods.

## Why Should Software Engineers Care?

**Thread pools**: `os.cpu_count()` returns 64 on a 32-core hyperthreaded system, but half are siblings sharing execution
units. For CPU-bound work, use `cpu_count // 2`. In containers, it returns host CPU count (64) not your limit (500m =
0.5 CPU).

**More resources can hurt**: 8 to 16 vCPUs might span two NUMA nodes → 50% remote memory access → 1.5-2x latency →
throughput drops.

**Standard metrics hide problems**: CPU % doesn't show steal time (`%st` in `top`), throttling (
`container_cpu_cfs_throttled_seconds_total`), or context switches (`cs` in `vmstat`).

**Defensive design**: Use timeouts, circuit breakers, and monitor P99 latency + throttling rate.

## Kubernetes CPU Configuration

Kubernetes schedules based on **requests**, not limits.

Problem with `requests: 100m, limits: 500m`: Scheduler packs 20 pods on a 2-core node (2000m requests). All burst to
limits → 10,000m demand → 5x overcommit → throttling cascade.

Better: `requests: 500m` with no limits (CPU is compressible), or `limits: 2000m` for 4x burst headroom.

## Common Failure Patterns

**Hypervisor overcommit**: 10:1 vCPU:pCPU ratio → traffic spike → all VMs wake → steal time hits 20-30% → timeouts →
retries → cascade. Guest CPU shows 40% (looks fine), only steal time reveals the problem.

**Context switch explosion**: 200 threads on 8 CPUs → kernel spends 50% time switching → cache evictions → CPU shows "
90% busy" but useful work drops. Fix: Match thread count to CPUs.

**Hyperthreading trap**: 128 "CPUs" in `/proc/cpuinfo` → create 128 threads → half are siblings fighting for execution
units → performance tanks.

## Monitoring Across Layers

Correlate metrics across layers:

- **Business**: P99 latency, error rate
- **Container**: Throttling rate (`throttled_periods / total_periods`), CPU vs limit
- **VM/Host**: Steal time (`%st`), context switches (`cs`), run queue depth

Alert on P99 latency degradation, steal time > 5%, throttling > 10%, context switches > 50k/sec.

## Final Thoughts

"CPU" means different things at each layer:

- **Physical**: Cores with execution units (ALU, FPU), potentially shared via hyperthreading
- **Virtualization**: vCPUs as promises scheduled onto pCPUs
- **Container**: Quota-based throttling, not actual CPUs

When debugging "low CPU usage" with poor performance, check layers standard metrics don't show: hypervisor queues (steal
time), container throttling, or NUMA remote access.
