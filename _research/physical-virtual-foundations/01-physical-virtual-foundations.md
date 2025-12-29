# Physical & Virtual Foundations: Operational Deep Dive

## 1. Build the Mental Model (Before Tools)

**The core illusion**: People think of servers as uniform compute pools. In reality, modern servers are **hierarchical
NUMA archipelagos** where distance equals cost.

**What's actually happening:**

A modern server is multiple computers pretending to be one. Each CPU socket has its own memory controllers, PCIe lanes,
and L3 cache. When CPU 0 needs memory attached to CPU 1, it crosses the interconnect (QPI/UPI/Infinity Fabric) - adding
40-100ns of latency. This doesn't sound like much until you're doing millions of operations.

**Finite resources most people ignore:**

- **Memory bandwidth** (not just capacity) - ~100 GB/s per socket, shared by all cores
- **PCIe lanes** - NVMe, NICs, GPUs all compete for these
- **TLB entries** - only ~1500 entries, causing page walk storms with large working sets
- **CPU interconnect bandwidth** - saturates before you expect

**Where queues hide:**

- Hypervisor scheduler run queues (invisible to guest OS)
- NUMA remote memory access queues
- IO scheduler (both guest and host)
- Network virtqueue in virtio devices

**The backpressure that doesn't exist:**
When you overcommit memory, the hypervisor starts swapping or ballooning. The guest OS has no idea. Its memory metrics
look fine. Performance degrades mysteriously. There's no signal crossing the abstraction boundary.

**Common illusions vs reality:**

| People believe            | What actually happens                                             |
|---------------------------|-------------------------------------------------------------------|
| "8 vCPUs = 8 real CPUs"   | vCPUs are lottery tickets for physical CPU time slices            |
| "My VM has dedicated RAM" | Host is overcommitted 2:1, relies on deduplication and ballooning |
| "Local disk = fast"       | It's a QCOW2 file on network storage with 4 abstraction layers    |
| "CPU steal time is rare"  | 5-10% steal is normal in cloud environments                       |

---

## 2. Explore Failure First

### Failure Mode 1: NUMA Cross-Socket Memory Access

- **Degrades first**: Tail latency (P99) while P50 looks fine
- **Misleading metric**: Overall CPU utilization (~60%, seems healthy)
- **What actually matters**: `numastat` showing remote_node hits, cross-socket traffic bandwidth
- **The trap**: Engineer sees "plenty of CPU headroom" and adds more load, making it worse

### Failure Mode 2: Memory Overcommit + Sudden Working Set Growth

- **Degrades first**: Throughput collapses (10x drop in 30 seconds)
- **Misleading metric**: Guest OS `free -m` shows available memory
- **What actually matters**: Host kernel `dmesg` showing OOM kills, `vmstat si/so` on host
- **The trap**: Application team insists "we're not OOM" while hypervisor is thrashing

### Failure Mode 3: vCPU Count > Physical Core Count

- **Degrades first**: Scheduler jitter causes tail latency spikes
- **Misleading metric**: Low average CPU usage inside VM
- **What actually matters**: `schedstats`, CPU ready time (VMware) or steal time (Linux)
- **The trap**: "We have 16 vCPUs but only use 4 on average" - the other 12 cause context switching overhead

### Failure Mode 4: Network Virtio Queue Saturation

- **Degrades first**: Packet loss under load (TCP retransmits spike)
- **Misleading metric**: Network interface shows low utilization
- **What actually matters**: `ethtool -S` showing rx_queue_N_drops, interrupt rate
- **The trap**: "Network has capacity" while single-queue virtio NIC is bottlenecked at ~800kpps

### Failure Mode 5: Disk IO Through Too Many Layers

- **Degrades first**: Write latency becomes bimodal (most fast, some 1000x slower)
- **Misleading metric**: `iostat` inside VM shows reasonable await times
- **What actually matters**: Host-level qemu block device stats, underlying storage queue depth
- **The trap**: VM sees cached writes as "complete" while host is backlogged

### Failure Mode 6: CPU Pinning Conflicts

- **Degrades first**: Some VMs randomly slow down during peak hours
- **Misleading metric**: Individual VM CPU metrics look normal
- **What actually matters**: Host showing CPU cores with >200% scheduling contention
- **The trap**: Multiple VMs pinned to same physical cores, host scheduler can't rebalance

### Failure Mode 7: Transparent Huge Pages (THP) Compaction Stalls

- **Degrades first**: Random multi-second pauses in application
- **Misleading metric**: Memory usage is stable
- **What actually matters**: `/proc/vmstat` showing `thp_fault_fallback`, `compact_stall`
- **The trap**: Kernel spending 5 seconds defragmenting memory to create 2MB pages

---

## 3. Tradeoffs, Constraints, and Irreversibility

### Decisions that feel safe early but cause pain at scale:

**Memory overcommit** - Letting hypervisor overcommit 2:1 or 3:1 seems fine with low-memory workloads. Then someone
deploys a Java heap or in-memory cache. Suddenly you're in a world where the only fix is to massively reduce VM density
or add physical RAM to every host.

**virtio instead of SR-IOV** - virtio is easier, more portable, requires no special hardware config. But you've locked
in an interrupt and context-switch tax on every packet. Migrating thousands of VMs to SR-IOV later requires
reboot/downtime.

**Large VM sizing** - Giving VMs 32+ vCPUs "just in case" creates monsters that can't be live-migrated easily, NUMA-span
by default, and lock up resources. Rightsizing later requires application re-architecture.

### Decisions that are hard/impossible to reverse:

**NUMA node spanning** - Once you deploy VMs sized larger than a single NUMA node, you're committed to cross-socket
traffic forever. The VM can't be made smaller without app changes.

**Block device format choice** - Started with QCOW2 for snapshots? Moving to raw for performance requires VM downtime
and potentially TB of data migration.

**Hypervisor choice** - VMware to KVM (or vice versa) is an 18-month migration program, not a config change.

### Where teams over-optimize prematurely:

CPU pinning - Most workloads don't need it. Teams spend weeks tuning pinning topology before measuring whether NUMA
locality even matters for their app.

Huge pages - Configuring static huge pages is complex and fragile. THP handles 80% of the benefit with zero config.

### Where teams delay until failure forces it:

**Network multi-queue** - Running with single-queue virtio until mysterious packet loss appears under load.

**Disk IO tuning** - Default IO scheduler, queue depths, and elevator settings work until they catastrophically don't at
scale.

**Monitoring the host layer** - Everyone monitors the guest. Almost nobody monitors hypervisor-level steal time, NUMA
stats, or queue depths until production breaks.

---

## 4. Socratic Questions (Do Not Answer)

1. If memory bandwidth saturates on one NUMA node, what breaks first - cache-heavy workloads or streaming workloads, and
   why?

2. You have a 32-core server. Is it better to run four 8-vCPU VMs or eight 4-vCPU VMs? What assumption must be true for
   your answer to hold?

3. Your VM shows 2% CPU steal time. Is this fine, concerning, or catastrophic? What context do you need to decide?

4. If you could remove either CPU overcommit OR memory overcommit from your infrastructure, which would you eliminate
   and why?

5. An application does 100k IOPS in a VM with local NVMe passthrough. You move it to virtio-blk on network storage
   doing "only" 50k IOPS but it runs 10x slower. Why aren't IOPS the right metric?

6. Two identical VMs on the same host. One performs perfectly, one has terrible tail latency. What's the first place you
   look?

7. You're designing VM sizes. What's the danger zone between "too small" and "too large" in terms of vCPU count?

8. The hypervisor shows memory ballooning is active but not swapping. The guest shows no memory pressure. Who's lying?

9. If cross-NUMA memory access adds 60ns of latency, at what request rate does this become the dominant cost?

10. What would you sacrifice first under hypervisor resource pressure - CPU shares, memory guarantees, or storage IOPS -
    and what second-order effect will that trigger?

---

## 5. Production Lifecycle Mapping

### Day 1: Getting it running

**Technical**: Default VM templates work. Everything over-provisioned. Performance is fine because load is low. virtio,
NUMA-spanning, memory overcommit all invisible.

**Human**: Engineering thinks "virtualization is free overhead." Infra team hasn't instrumented hypervisor metrics yet.

**What seeds future problems**: No resource limits set. No pinning strategy. VMs sized by guesswork.

### Day 2: Keeping it safe and observable

**Technical**: First production incidents related to "mysterious slowness." Team adds guest-level monitoring but can't
explain 10% missing CPU time (steal). Alert fatigue from bimodal disk latency.

**Human**: Application team blames infrastructure. Infrastructure team blames noisy neighbors. No shared mental model of
the stack.

**What's needed**: Host-level dashboards showing steal, NUMA stats, queue depths. SLOs that account for virtualization
tax.

### Day N: Scaling, cost, and organizational impact

**Technical**: Fleet is mixed-generation hardware. Some hosts have 18-core CPUs, some have 64-core. VM sizing doesn't
account for this. Placement decisions cause random performance variance.

**Human**: Finance wants higher VM density (more overcommit). Engineering wants guaranteed performance (less
overcommit). No one can articulate the tradeoff quantitatively.

**Organizational failure mode**: Teams create "dedicated host" carveouts for "important" workloads, fragmenting capacity
and increasing cost. Or they run everything on bare metal, losing flexibility.

---

## 6. High-Signal Experiments

### Experiment 1: Cross-NUMA Memory Access Penalty

- **Setup**: VM with memory spread across NUMA nodes, run `numactl --membind=0` then `--membind=1` with memory-bound
  workload
- **Trigger stress**: Use `sysbench memory` or similar
- **What this teaches**: Actual latency multiplier of remote memory (typically 1.4-2.5x), shows up in tail latency not
  average
- **Time**: 30 minutes

### Experiment 2: vCPU Oversubscription Breaking Point

- **Setup**: Single host, gradually add VMs until total vCPUs = 2x physical cores, then 4x
- **Trigger stress**: Run CPU-bound work in all VMs simultaneously
- **What this teaches**: When does scheduler overhead dominate? Watch context switch rate and steal time explode
  non-linearly
- **Time**: 45 minutes

### Experiment 3: Memory Overcommit + Working Set Spike

- **Setup**: Host with 2:1 memory overcommit, multiple idle VMs
- **Trigger stress**: Rapidly allocate and touch memory in one VM (e.g., `stress-ng --vm 1 --vm-bytes 8G`)
- **What this teaches**: Ballooning/swapping threshold, time to detect and react, blast radius to other VMs
- **Time**: 20 minutes

### Experiment 4: Single-Queue vs Multi-Queue Network

- **Setup**: virtio NIC, run `iperf3` or packet generator
- **Trigger stress**: Single queue, then enable multi-queue (`ethtool -L`)
- **What this teaches**: Where single-queue breaks (packets per second, not bandwidth), interrupt distribution matters
- **Time**: 30 minutes

### Experiment 5: IO Path Latency Stacking

- **Setup**: Same workload on bare metal NVMe, then VM with virtio-blk on same NVMe, then VM with virtio-blk on network
  storage
- **Trigger stress**: `fio` with low queue depth (QD=1) random reads
- **What this teaches**: Cost of each abstraction layer (virtio ~10μs, network ~100μs), why latency matters more than
  throughput
- **Time**: 40 minutes

---

## 7. Red Flags & Anti-Patterns

### "The hypervisor will handle resource contention automatically"

**Why risky**: Hypervisor schedulers optimize for fairness and throughput, not latency. They'll happily let your
latency-sensitive service wait 50ms for CPU while a batch job runs. Automatic doesn't mean good for your use case.

### "We allocate based on average utilization"

**Why risky**: The P99 spike that happens for 30 seconds determines whether your service meets SLO. Average utilization
is a capacity planning metric, not a performance metric. That 20% average hides the 95% spike that causes timeouts.

### "Memory is cheap, just add more RAM"

**Why risky**: Memory bandwidth is NOT cheap and doesn't scale with capacity. You can have 512GB of RAM but still be
bottlenecked at 100GB/s bandwidth. Adding more NUMA nodes makes the problem worse.

### "We've never seen steal time be a problem before"

**Why risky**: You've never measured it properly, or never ran at this scale, or the workload changed. Steal time under
5% is invisible in most apps, but it's bimodal - 95% of the time it's 0%, 5% of the time it's 50%. That 5% causes all
your timeouts.

### "Cloud provider guarantees this IOPS/bandwidth"

**Why risky**: They guarantee it over 5-minute windows with burst credits. Your database needs it *right now* during the
commit. Marketing guarantees aren't SLAs, and SLAs have loopholes.

### "Bare metal is always faster, so we'll just use that"

**Why risky**: You've traded 10-15% performance tax for operational flexibility. When that bare metal host's DIMM fails
at 2AM, you're doing a multi-hour recovery instead of a 60-second live migration. Pick your tradeoff consciously.

### "We'll tune this later when it becomes a problem"

**Why risky**: Later means during an outage. Some tuning (NUMA binding, huge pages config) requires VM restart. You
won't get approval to restart production during an incident. Either tune in advance or accept you won't be able to tune.

---

## 8. Synthesize Into Operator Truths

1. **Steal time below 5% is probably fine; above 10% is production-impacting; above 20% means you're in a resource fight
   you can't win without less density or more hardware.**

2. **If a VM spans NUMA nodes, you've already lost 30-40% potential performance. No amount of tuning recovers that. Size
   VMs to fit in one node or accept the tax.**

3. **Memory overcommit works until it doesn't, and when it doesn't, it fails catastrophically with no gradual
   degradation. Ballooning and swapping are emergency brakes, not operational modes.**

4. **The guest OS cannot tell you what the hypervisor is doing to it. If you only monitor inside VMs, you're flying
   blind through the most common failure modes.**

5. **Network and disk performance degrade with contention in ways that don't show up in utilization metrics. Watch queue
   depths, drops, and latency distributions, not bandwidth percentages.**

---

## Next Steps

Pick one or more of the experiments above to run, or dive deeper into any section that resonates with your current
challenges.
