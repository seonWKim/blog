---
title: "Physical Virtual Foundations - Queues in VM"
date: 2025-12-28 00:00:01 -0500
categories: infra
tags: [ infra, NUMA, core, socket ]
---

Virtualization maximizes hardware utilization by adding an extra abstraction layer. Whenever we add another layer, it
introduces unpredictability and this is why we need to understand deeper when we are working on piles of abstraction
layers. And queues in virtualized environment are a great example.

## Hypervisor CPU scheduling

VMs running on the hypervisor have their vCPUs in order to run processes. Because vCPUs have to run on physical CPUs,
they compete for CPU resources. And to handle those requests, CPU will queue those requests. When CPU usage is high, it
might take long for the vCPU to acquire real CPU time. For this case, your guest OS's CPU time might be low (e.g. 2%)
but performance is terrible because the vCPU is spending most of it's time waiting in the hypervisor's run queue. It's
seen as a percentage (`%st` in Linux tools like `top`), showing CPU cycles your VM requested but didn't receive, and
it can be fixed by reducing host load, increasing VM resources, or optimizing scheduling.

## NUMA remote memory access queue

When a CPU has to access remote memory, requests queue up in the interconnect. NUMA (Non-Uniform Memory Access) is an
architecture where each CPU socket has its own local memory. If your VM spans multiple NUMA nodes, memory access
patterns create hidden queuing. A single-threaded workload might mysteriously slow down because the thread migrated to a
different NUMA node and now all its memory is remote. You can use `numastat` to view your system's NUMA memory access
patterns.

## I/O scheduler

In virtualized environment, a process has to pass 2 schedulers - guest OS scheduler and host OS scheduler in order to
fully run their tasks. This creates double buffering which means that requests can queue at both layers. In cloud
environment, you tune the I/O scheduler inside your VM, but the host has its own scheduler making different decisions.
This might lead to unpredictable latency spikes.

## Final thoughts

If you're operating on an environment which has abstraction layers in between, it's important to understand the inner
workings otherwise you'll not be able to find the root cause of operational issues. How would you solve low CPU usage of
the guest OS if you don't know how it interacts with the host CPU? Understanding these hidden queues helps you look
beyond guest metrics and consider the layers underneath when debugging performance issues. 