---
title: "Physical Virtual Foundations - NUMA"
date: 2025-12-28
categories: infra
tags: [ ]
---

As a software engineer, I often forget the importance of getting used to hardware system that software system runs on.
As I'm diving into the hardware world, I found myself not familiar with the hardware related terms, so I would like to
start myself with defining unfamiliar hardware terms. For today, I would like to start with NUMA architecture.

## NUMA(Non-Uniform Memory Access)

NUMA, NUMA, NUMA.. I've heard of this term so many times. It's a computer memory architecture where memory access time
depends on the memory's location relative to the processor.

In NUMA, CPUs have their own local memory. But they can also access other CPUs local memories. So the access time
depends on the distance between memory and CPU, hence called non-uniform memory access. This was introduced to solve
scalability problem. If CPUs were to share a single memory and memory bug, they can become the bottleneck. NUMA allows
systems to scale by having each CPUs to have their own memory.

### Why Software Engineers should care?

For software engineers like us, we love and need to think in the perspective of software performance. When we run our
software on NUMA systems, we have to consider CPU memory locality because allowing the CPU to access it's local memory
is 2-10x faster than remote memory access. By writing your system NUMA-aware, you are now possible to enhance the system
performance. If you're an I/O bound application developer, maybe we can skip NUMA, but if you are developing performance critical software such as databases or
servers, NUMA seems to be a basic knowledge for everyone.

Best practices suggested by my best professor (ai):

- Pin threads to specific NUMA nodes for consistent performance
- Use NUMA-aware allocators e.g. `tcmalloc`, `jemalloc` 😮😮
- Apply NUMA topology in thread pool design
- For databases: configure bugger pools per NUMA node -> seems interesting. Let's do some research on databases in the
  future 

### NUMA topology in thread pool design 

### NUMA Aware Buffer Pools in Databases?  


