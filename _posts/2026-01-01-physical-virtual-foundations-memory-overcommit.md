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

## Key Mechanisms

### Ballooning

The hypervisor inflates a fake driver inside the guest that allocates memory, letting it reclaim physical RAM for other
VMs. The guest sees less free memory but doesn't know why.

Critical limitation: If your application's working set grows faster than the balloon can reclaim memory, overcommit is
incompatible with your SLO. No tuning fixes this architectural mismatch.

### Swapping vs Thrashing

**Swapping**: Moving pages between RAM and disk. Occasional swapping causes minor slowdown.

**Thrashing**: Constant swapping where the system does nothing but swap. Once working set exceeds physical RAM, you
enter a death spiral - every page swapped in requires swapping another page out that's immediately needed. Not gradual
degradation, but a cliff.

## Why Should Software Engineers Care?

### Working Sets Matter More Than Allocation

- **Allocated memory**: Total given to VM (e.g., 16GB)
- **Working set**: Memory actually accessed recently (e.g., 4GB)

A VM using 4GB of 16GB allocation isn't "wasting resources" - it's enabling density. Those unused 12GB let other VMs use
physical RAM.

**Overcommit works when**: Total working set of all VMs < Physical RAM
**Overcommit fails when**: Total working set of all VMs > Physical RAM

This is why synchronized batch jobs are deadly - 20 VMs all expand working sets simultaneously.

### Common Failure: Synchronized Workloads

20 VMs, each allocated 4GB, host has 64GB physical. Daily batch jobs start at midnight across all VMs.

- Throughput collapses (10 minutes → 2 hours)
- Guest `free -m` shows 1-2GB free per VM
- Host `vmstat si/so` shows swap activity
- Each owner says "my VM is fine" while host thrashes

### Common Failure: Java Heap + Ballooning

VM with 16GB runs JVM with `-Xmx12g`, host at 1.5:1 overcommit, JVM does full GC.

- GC pauses spike (milliseconds → seconds)
- JVM logs show "normal" heap
- Host is ballooning during GC
- Database reports high cache hit ratios while hypervisor swapped pages to disk

### Metrics That Actually Matter

Three metrics to detect overcommit problems:

1. **Host swap in/out (si/so)** - leading indicator before cliff
2. **Host memory usage %** - how close to edge
3. **Balloon inflation across VMs** - host in panic mode

Guest metrics are necessary but insufficient for debugging.

## What This Means for Us

**You cannot trust allocation**. Your 16GB VM might have 16GB, 12GB, or 8GB physical RAM backing it. The hypervisor
won't tell you.

**SLOs might be impossible**. Hypervisor-injected page faults break p99 latency promises regardless of code tuning.

**Working set measurement is your job**. If you can't articulate actual working set vs allocation, infra will
over-allocate, enabling overcommit and creating problems.

**Design for degradation**. Guest OOM won't fire when host is swapping your pages - you'll get massive slowdowns, not
failures.

## Final Thoughts

The lesson isn't "never use overcommit." It's understanding where abstractions break. The guest lives in one reality (
allocated memory), the host in another (physical memory), with no protocol for truth-telling. For software engineers
moving into infrastructure, memory overcommit shows why you need the full stack - guest metrics are necessary but
insufficient for the most confusing production issues.
