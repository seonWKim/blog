---
title: "Physical Virtual Foundations - Memory Overcommit"
date: 2026-01-01 00:00:01 -0500
categories: infra
tags: [ infra, virtualization, memory, hypervisor ]
---

I keep encountering VM performance issues that guest metrics can't explain. Memory overcommit is one of those
abstraction boundaries where the guest OS lives in a different reality than the host.

## What is Memory Overcommit?

When you allocate 8GB to a VM, you're creating an 8GB address space the hypervisor will *try* to back with physical
RAM - not a guaranteed reservation. The hypervisor bets that VMs won't all use their full allocation simultaneously,
enabling higher density through memory deduplication, ballooning, and swapping.

The problem: **there's no backpressure signal crossing the abstraction boundary**. When the host runs out of physical
RAM, the guest has no idea.

### The Missing Feedback Loop

Normal system running out of memory:

- `malloc` fails or OOM killer runs
- Application crashes with clear errors
- Monitoring alerts fire

With memory overcommit:

- Host runs out of physical RAM
- Hypervisor balloons/swaps (guest unaware)
- Applications slow down without failing
- Guest metrics show "everything is fine"
- Days of debugging "mysterious slowness"

The guest thinks it has 16GB. The host knows only 12GB exists physically. This information asymmetry wastes debugging
time - you're looking at metrics that can't show the problem.

## How Hypervisors Hide the Truth

To understand why debugging is so difficult, we need to see how hypervisors manage overcommit. They use two main
techniques to reclaim memory when physical RAM runs low - and both are invisible to the guest.

### Ballooning

The hypervisor inflates a fake driver inside the guest that allocates memory, letting it reclaim physical RAM for other
VMs. The guest sees less free memory but doesn't know why.

**How Ballooning Works:**

```
Initial State - Host with 16GB Physical RAM
┌─────────────────────────────────────────────────────────┐
│                    HOST (16GB Total)                     │
├──────────────┬──────────────┬──────────────┬────────────┤
│   VM1 (8GB)  │   VM2 (8GB)  │   VM3 (8GB)  │  Free 4GB  │
│   Using 6GB  │   Using 6GB  │   Using 4GB  │            │
└──────────────┴──────────────┴──────────────┴────────────┘
  Total used: 16GB physical RAM (full!)


Host needs memory - triggers ballooning in VM1 & VM2
┌─────────────────────────────────────────────────────────┐
│                         HOST                             │
├──────────────┬──────────────┬──────────────┬────────────┤
│     VM1      │     VM2      │     VM3      │            │
│  ┌────────┐  │  ┌────────┐  │              │            │
│  │Balloon │  │  │Balloon │  │  Apps: 4GB   │            │
│  │  2GB   │  │  │  2GB   │  │              │            │
│  ├────────┤  │  ├────────┤  │              │            │
│  │Apps:4GB│  │  │Apps:4GB│  │              │            │
│  └────────┘  │  └────────┘  │              │            │
└──────────────┴──────────────┴──────────────┴────────────┘
                                              ↑ 4GB reclaimed


Guest Perspective (VM1):
┌─────────────────────────────────┐
│  VM1 sees: 8GB allocated        │
│                                 │
│  Before ballooning:             │
│    Used: 6GB                    │
│    Free: 2GB                    │
│                                 │
│  After ballooning:              │
│    Used: 8GB (Apps: 6GB)        │
│           (Balloon: 2GB) ← ?!   │
│    Free: 0GB                    │
│                                 │
│  Guest thinks: "I'm out of      │
│  memory, better reclaim cache"  │
│  Guest doesn't know: Balloon    │
│  gave memory back to host       │
└─────────────────────────────────┘


Host reallocates reclaimed memory to VM3
┌─────────────────────────────────────────────────────────┐
│                         HOST                             │
├──────────────┬──────────────┬──────────────┬────────────┤
│     VM1      │     VM2      │     VM3      │  Free 0GB  │
│  ┌────────┐  │  ┌────────┐  │              │            │
│  │Balloon │  │  │Balloon │  │  Apps: 8GB   │            │
│  │  2GB   │  │  │  2GB   │  │  (needs more │            │
│  ├────────┤  │  ├────────┤  │   memory)    │            │
│  │Apps:4GB│  │  │Apps:4GB│  │              │            │
│  └────────┘  │  └────────┘  │              │            │
└──────────────┴──────────────┴──────────────┴────────────┘
  Physical RAM: Still 16GB, now supporting 24GB allocated
```

Critical limitation: If your application's working set grows faster than the balloon can reclaim memory, overcommit is
incompatible with your SLO. No tuning fixes this architectural mismatch.

When ballooning can't reclaim memory fast enough, the hypervisor falls back to swapping - which is where things get
worse.

### Swapping vs Thrashing

**Swapping**: Moving pages between RAM and disk. Occasional swapping causes minor slowdown.

**Thrashing**: Constant swapping where the system does nothing but swap. Once working set exceeds physical RAM, you
enter a death spiral - every page swapped in requires swapping another page out that's immediately needed. Not gradual
degradation, but a cliff.

## Why Should Software Engineers Care?

Now that we know how overcommit hides itself, the question is: when does it break? The answer isn't about allocated
memory - it's about working sets. This mental model explains why some VMs coexist peacefully while others destroy each
other's performance.

### Working Sets Matter More Than Allocation

- **Allocated memory**: Total given to VM (e.g., 16GB)
- **Working set**: Memory actually accessed recently (e.g., 4GB)

A VM using 4GB of 16GB allocation isn't "wasting resources" - it's enabling density. Those unused 12GB let other VMs use
physical RAM.

**Overcommit works when**: Total working set of all VMs < Physical RAM

**Overcommit fails when**: Total working set of all VMs > Physical RAM

This explains two common production failures that look mysterious until you understand working sets.

### Common Failure: Synchronized Workloads

20 VMs, each allocated 4GB, host has 64GB physical. Daily batch jobs start at midnight across all VMs.

- Throughput collapses (10 minutes → 2 hours)
- Guest `free -m` shows 1-2GB free per VM
- Host `vmstat si/so` shows swap activity
- Each owner says "my VM is fine" while host thrashes

The batch job example shows synchronized spikes. But even a single VM can cause problems if its working set fluctuates
dramatically.

### Common Failure: Java Heap + Overcommit

Host with 64GB physical RAM runs 6 VMs, each allocated 16GB (96GB total = 1.5:1 overcommit). One VM runs JVM with
`-Xmx12g`.

Normal state: JVM working set is ~4GB (young gen + active old gen objects being actively used), other VMs using ~10GB each.
Total working set ~54GB fits in 64GB physical.

During full GC: JVM must scan and compact the entire heap, reading and writing to pages across all 12GB. These memory accesses
bring pages into the working set, spiking this VM's working set from 4GB to 12GB+.

- Total working set now exceeds 64GB physical RAM
- Host swaps pages from this VM (or balloons other VMs) to free physical RAM
- GC pauses spike from milliseconds to seconds due to page faults
- JVM logs show "normal" GC activity - no indication of swapping
- Guest metrics show nothing wrong while host is swapping

Both failures share the same root cause: guest metrics can't see host behavior. So what should you monitor instead?

### Metrics That Actually Matter

Three metrics to detect overcommit problems:

**1. Host swap in/out (si/so) - leading indicator before cliff**

On Linux hosts, use `vmstat 5` to monitor swap activity:

```
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0      0 24576   2048  8192     0    0    20    10  150  300  5  2 93  0  0  ← healthy
 2  1 403256  4096   1024  2048   124  256    50   150  400  800 20 10 60 10  0  ← pressure
 4  3 856432  2048    512  1024   892 1456   180   420  850 1600 30 20 30 20  0  ← thrashing
```

Watch for the pattern:
- **Healthy**: si/so consistently at 0
- **Memory pressure**: sustained non-zero si/so values
- **Thrashing**: si/so increasing across samples, free memory near 0, wait time (wa) climbing

**2. Host memory overcommit ratio - how close to edge**

VMware ESXi example from esxtop:

```
           PMEM  %    /MB   VMKMEM   COSMEM  OVHD     /MB   COWSZ  SHRD   SHDCMN  BALLOON  SWAP  COMPR  COMPRESS
ESXi host: 64GB  92%  59136  2048     57088   2048    4096  128    8192   512     4096     2048  1024   128
```

Watch the PMEM % (physical memory usage) and BALLOON/SWAP columns:
- **Safe**: Low memory %, zero or minimal balloon/swap activity
- **Approaching limits**: High memory % with increasing balloon/swap values
- **Critical**: Memory % near capacity, active ballooning/swapping across multiple VMs

**3. Balloon inflation across VMs - host in panic mode**

VMware vCenter performance graph showing VM balloon usage (metric: `mem.vmmemctl.average`):

```
VM1 (16GB allocated):  2048 MB ballooned
VM2 (16GB allocated):  4096 MB ballooned
VM3 (8GB allocated):   5120 MB ballooned
```

Watch for these patterns:
- **Normal**: 0 MB ballooned across all VMs
- **Memory pressure**: Sustained ballooning across multiple VMs
- **Crisis**: Ballooning values increasing over time, especially if approaching significant percentage of VM allocation

When you see balloon values > 0 persisting across multiple VMs, the host is in memory pressure and actively reclaiming
memory from guests.

Guest metrics are necessary but insufficient for debugging.

## What This Means for Us

Understanding the mechanisms and metrics is useful, but what changes in how we build and operate systems?
- **You cannot trust allocation**. Your 16GB VM might have 16GB, 12GB, or 8GB physical RAM backing it. The hypervisor
won't tell you.
- **SLOs might be impossible**. Hypervisor-injected page faults break p99 latency promises regardless of code tuning.
- **Working set measurement is your job**. If you can't articulate actual working set vs allocation, infra will
over-allocate, enabling overcommit and creating problems.
- **Design for degradation**. Guest OOM won't fire when host is swapping your pages - you'll get massive slowdowns, not
failures.

## Final Thoughts

The lesson isn't "never use overcommit" - it's recognizing when the abstraction breaks down. Overcommit works when
working sets stay predictable and stay below physical RAM. It fails catastrophically when working sets spike
synchronously or fluctuate unpredictably.

The fundamental problem is the missing feedback loop. The guest lives in one reality (allocated memory), the host in
another (physical memory), with no protocol for truth-telling. Ballooning and swapping happen silently. Your application
slows down without failing, metrics show nothing wrong, and you spend days debugging phantom issues.

For software engineers moving into infrastructure work, memory overcommit demonstrates why you need visibility across
abstraction boundaries. Guest metrics are necessary but insufficient. Host metrics reveal the truth. Understanding both
is the difference between days of confusion and minutes of diagnosis.
