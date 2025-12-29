# Hidden Queues in Virtualized Systems

## Overview

Where queues hide in virtualized infrastructure:

- Hypervisor scheduler run queues (invisible to guest OS)
- NUMA remote memory access queues
- IO scheduler (both guest and host)
- Network virtqueue in virtio devices

## Roles and How They Work

### 1. Hypervisor Scheduler Run Queues

**Role:** Decides which guest vCPU gets time on which physical CPU core.

**How it works:**
- Each physical CPU has a run queue of vCPUs waiting for CPU time
- The hypervisor (e.g., KVM, ESXi) schedules vCPUs like processes, but the guest OS *cannot see* this layer
- A vCPU might be "running" from the guest's perspective but actually queued in the hypervisor

**Key insight:** Your guest OS shows 2% CPU usage, but performance is terrible because the vCPU is spending most of its time waiting in the hypervisor's run queue. This is called the "steal time" problem.

---

### 2. NUMA Remote Memory Access Queues

**Role:** Manages memory access when CPU needs data from memory attached to a *different* CPU socket.

**How it works:**
- In NUMA systems, each CPU socket has local memory (fast) and remote memory (slow)
- When a CPU accesses remote memory, requests queue up in the interconnect (e.g., Intel QPI/UPI)
- Remote access can be 2-3x slower than local access

**Key insight:** If your VM spans multiple NUMA nodes, memory access patterns create hidden queuing. A single-threaded workload might mysteriously slow down because the thread migrated to a different NUMA node and now all its memory is remote.

---

### 3. IO Scheduler (Guest and Host)

**Role:** Reorders and batches disk I/O requests to optimize for the underlying storage device.

**How it works:**
- **Guest OS scheduler** (e.g., mq-deadline, none): Reorders I/O within the VM
- **Host OS scheduler**: Reorders I/O again for the physical device
- This creates **double buffering** - requests can queue at both layers

**Key insight:** You tune the I/O scheduler inside your VM, but the host has its own scheduler making different decisions. In cloud environments, you often can't control or even see the host scheduler, leading to unpredictable latency spikes.

---

### 4. Network virtqueue (virtio)

**Role:** Provides a shared memory queue between guest and host for network packets.

**How it works:**
- Guest driver writes packet descriptors to a ring buffer (virtqueue)
- Host reads from the same buffer and transmits packets
- Uses memory-mapped I/O to avoid expensive VM exits for each packet

**Key insight:** The virtqueue has a fixed size. If the guest produces packets faster than the host can consume them, the queue fills up and packets get dropped *before* they even reach the network. This looks like "network issues" but it's actually a local queuing problem.

---

## Operational Insights

### Why This Matters

1. **Observability Blindness:** Guest OS metrics show one reality, but 3-4 layers of hidden queues exist below it. Your monitoring sees low CPU usage while the app is starving for compute.

2. **Latency Stacking:** Each queue adds latency. A disk write passes through: guest page cache → guest I/O scheduler → virtio queue → host I/O scheduler → hardware queue. That's 5 queuing points before the actual write.

3. **Backpressure Breaks:** In physical systems, backpressure is often natural. In virtualized systems, queues *hide* backpressure until saturation causes sudden catastrophic failure.

4. **The Noisy Neighbor Problem:** Other VMs on the same host compete for the same hypervisor run queue, NUMA bandwidth, and host I/O scheduler. Your performance varies based on what you *cannot observe*.

5. **False Optimization:** You tune the guest OS, but the bottleneck is in the hypervisor or hardware layer you can't access. This is why "best practices" from bare metal often fail in VMs.

### What to Watch For

- **Steal time** (shows hypervisor queuing): `top` shows `%st`
- **NUMA remote hit ratio**: `numastat` on host (if accessible)
- **Virtio queue drops**: Check virtio driver stats, not just network interface stats
- **I/O latency distribution**: p99 might be 100x higher than p50 due to queue buildup

## The Meta-Insight

**Virtualization trades predictability for efficiency.** These queues exist to maximize hardware utilization across many tenants, but they create performance that's hard to reason about or debug from inside the guest.