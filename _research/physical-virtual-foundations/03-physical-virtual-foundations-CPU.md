# Deep Dive: vCPUs & CPUs in Physical, Virtual, and Container Environments

---

## 1. Introduction

Understanding CPU behavior across bare metal, VMs, and containers is fundamental to operating reliable systems. The
same "CPU" means entirely different things depending on where you're standing, and this semantic overload causes most
production performance issues.

**What makes CPU complex in virtualized environments:**

The core problem is **abstraction leakage**. Applications assume "a CPU" means dedicated compute capacity. But in
reality:

- **Physical hardware** has sockets, cores, and hyperthreads with complex sharing patterns
- **Hypervisors** multiplex dozens of vCPUs onto physical cores through hidden run queues
- **Container runtimes** throttle CPU access using fixed time windows that punish bursty workloads

Performance becomes unpredictable because monitoring shows "CPU usage" but hides the queuing, throttling, and contention
happening beneath the surface.

**Why this matters operationally:**

You'll see "30% CPU utilization" while applications suffer 3x latency increase. Standard metrics measure consumption,
not availability. This guide builds the mental models needed to diagnose these hidden bottlenecks and design systems
that perform predictably at scale.

---

## 2. Terms and Definitions

### Physical Hardware Layer

**CPU Package (Socket)**: The physical chip installed in a motherboard socket. A dual-socket server has 2 physical CPU
packages.

**Core**: An independent execution unit inside a CPU package. Each core has its own ALU (arithmetic logic unit), FPU (
floating-point unit), L1 cache, and L2 cache. This is the only thing that actually executes instructions.

**Hardware Thread (Logical Processor)**: The schedulable unit the OS sees. With hyperthreading disabled: 1 core = 1
hardware thread. With hyperthreading enabled: 1 core = 2 hardware threads.

**Hyperthreading (HT) / Simultaneous Multithreading (SMT)**: Intel/AMD technology that allows one physical core to
present as two logical CPUs by adding a second architectural state (registers, program counter) while sharing execution
units.

**NUMA (Non-Uniform Memory Access)**: Multi-socket architecture where each socket has local memory (fast, ~80-100ns) and
can access other sockets' memory (slow, ~140-180ns, crosses inter-socket interconnect).

**Cache Hierarchy**:

- **L1**: 32-64 KB per core, private, ~4 cycle latency
- **L2**: 256 KB - 1 MB per core, private, ~12-15 cycle latency
- **L3 (LLC)**: 2-64 MB per socket, shared across cores, ~40-60 cycle latency

### Virtualization Layer

**Physical CPU (pCPU)**: A hardware thread on a physical core. The actual, finite execution resource.

**Virtual CPU (vCPU)**: A software abstraction presented to a guest OS. A promise that the hypervisor will schedule this
onto a pCPU. The guest OS cannot see whether it maps to a real core, hyperthread, or is overcommitted.

**Steal Time**: The percentage of time a vCPU wanted to run but couldn't because the hypervisor was executing other
vCPUs on the physical CPU. Visible in `top` as `%st`.

**vCPU Overcommit**: Running more vCPUs than pCPUs. Example: 20 vCPUs competing for 4 pCPUs (5:1 ratio).

### Container Layer

**CPU Request**: The amount of CPU Kubernetes uses for scheduling pod placement. Guarantees the node has this capacity
available.

**CPU Limit**: The maximum CPU a container can consume, enforced by cgroup throttling.

**CPU Throttling**: When a container exhausts its quota within a time period, the kernel hard-pauses (freezes) it at 0%
CPU until the next period starts.

**CFS (Completely Fair Scheduler)**: Linux kernel scheduler that implements CPU limits using quota/period mechanism with
tumbling windows.

**Quota/Period**: CPU limit of 500m (0.5 CPU) = 50ms quota per 100ms period (default).

---

## 3. Mental Model

### The Hierarchy of Abstraction

```
Application Thread
       ↓
   OS Scheduler
       ↓
  [Container cgroup limit - throttling boundary]
       ↓
   Hardware Thread (what OS schedules onto)
       ↓
  [Hypervisor scheduler - steal time happens here]
       ↓
   Physical Core (only thing that executes)
```

At each layer, something can queue or throttle, but layers above can't see it.

### What "CPU" Actually Means at Each Layer

**Physical Core (bare metal)**:

- Real execution hardware
- Exclusive - only 1 instruction stream at a time
- Finite and observable

**Hardware Thread (with hyperthreading)**:

- 2 logical CPUs per core, sharing execution units
- Not independent - siblings compete for ALU, FPU, cache
- Best case: 1.3-1.5x performance vs 1 thread (not 2x!)
- Worst case: 0.7x performance if siblings conflict

**vCPU (virtual machine)**:

- Software promise, not hardware guarantee
- Maps to pCPU via hypervisor scheduler (invisible to guest)
- Can be overcommitted - 8 vCPUs might share 2 pCPUs
- Guest OS sees "100% - steal%" actual availability

**Container CPU (cgroup)**:

- Not a CPU at all - a throttling mechanism
- Container sees all host CPUs in `/proc/cpuinfo`
- Kernel enforces quota using tumbling windows
- Hitting limit = hard freeze until next period

### The Core Problem: Hidden Queues

Physical CPUs are **exclusive**. When busy, something must wait. But where?

1. **Hypervisor run queue**: vCPUs waiting for pCPU time (causes steal time)
2. **Kernel run queue**: Processes/threads waiting for CPU (normal scheduling)
3. **CFS throttle queue**: Containers paused until quota resets (causes latency spikes)
4. **NUMA interconnect**: CPUs waiting for remote memory access (invisible slowdown)
5. **Cache coherency protocol**: Cores waiting for cache line ownership (invisible)

**The operational nightmare**: Your monitoring shows CPU metrics from layer 2 (kernel scheduler), but bottlenecks exist
at layers 1, 3, 4, and 5 which are invisible.

### Hyperthreading: The Shared Resource Illusion

A physical core has many execution units:

- Integer ALU
- Floating-point ALU
- Vector/SIMD (AVX, SSE)
- Load/store (memory access)
- Branch predictor
- Instruction decode

Hyperthreading adds a second **architectural state** (registers, program counter) but keeps **one set of execution units
**.

**OS sees**: 2 CPUs
**Hardware reality**: 1 core with shared ALU, FPU, cache

**When siblings help**: Thread A does integer math (uses ALU) while Thread B does floating-point (uses FPU) → parallel
execution

**When siblings hurt**: Both threads do AVX vector math → fight for FPU, each gets half throughput + cache thrashing

**The operational issue**: `/proc/cpuinfo` shows 64 processors on a 32-core HT system. Your application sees "64 CPUs"
and creates 64 threads. Context switching + cache thrashing makes performance worse than 32 threads.

### NUMA: When Memory Isn't Equal

On multi-socket systems:

- Each socket has local RAM (fast)
- Each socket can access other sockets' RAM (slow, crosses QPI/UPI interconnect)
- 1.5-2x latency penalty for remote access

**VM NUMA problem**:

- VM with 8 vCPUs on a 2-socket host
- 4 vCPUs on Socket 0, 4 vCPUs on Socket 1
- If memory is allocated from Socket 0, vCPUs on Socket 1 have 50% remote access
- 30-50% throughput degradation

**You can't see this from inside the VM.** The hypervisor controls vCPU placement and it changes over time.

### Steal Time: The Hypervisor Queue

```
Your VM thinks:
  "I have 4 vCPUs, CPU shows 40% busy, why is my app slow?"

Hypervisor reality:
  "Your 4 vCPUs are sharing 2 pCPUs with 3 other VMs.
   Your vCPUs spend 60% of time waiting in my run queue."
```

**Steal time** = time your vCPU was ready to run but waiting in the hypervisor queue

**Critical insight**: Steal time looks like idle time to your application. Your process thinks the OS is slow to
schedule it, but really the vCPU itself is queued at the hypervisor.

### CPU Throttling: The Tumbling Window Trap

CPU limits use **tumbling windows** (fixed 100ms periods):

```
Period 1      Period 2      Period 3
[0-100ms]     [100-200ms]   [200-300ms]
 50ms quota    50ms quota    50ms quota
```

**No carryover**: Unused quota is lost
**No borrowing**: Can't use future quota

**Example: Web request needing 60ms CPU with 500m (50ms/100ms) limit**

```
Period 1:
  0-50ms:   Process request (quota exhausted)
  50-100ms: FROZEN (throttled, 0% CPU)

Period 2:
  100-110ms: Complete request (10ms quota used)

Total latency: 110ms for 60ms of work
```

**Why this destroys performance**:

- Request frozen mid-execution for 50ms
- Node has idle CPU but container can't use it
- Latency becomes unpredictable (depends on when request arrives in period)

**Worse: wasted quota**

```
Workload: 10ms work, 150ms idle, repeat...

Period 1: 10ms used, 40ms wasted
Period 2: 0ms used, 50ms wasted (idle period)
Period 3: 10ms used, 40ms wasted
Period 4: 0ms used, 50ms wasted

Average: 20ms / 400ms = 5% CPU
Limit: 500m = 50% CPU
Using 10% of limit but getting throttled!
```

---

## 4. Failure Scenarios, Tradeoffs, and Constraints

### Failure 1: Hypervisor Overcommit Death Spiral

**Scenario**: Infrastructure team sets 10:1 vCPU-to-pCPU ratio because "VMs are mostly idle"

**What breaks**:

- Multiple VMs wake up simultaneously (log rotation, backups, traffic spike)
- All vCPUs fight for pCPUs
- Steal time spikes to 20-30%
- Every VM becomes 20-30% slower
- Cascading failure as timeouts trigger retries

**Misleading metrics**:

- Guest CPU shows 30-40% usage (looks fine!)
- No memory pressure
- No disk/network issues
- Steal time is only metric that shows the problem

**Why it's hard to reverse**:

- Rightsizing requires coordinating with every application team
- Apps have grown to depend on high vCPU counts
- Reducing vCPUs means re-benchmarking everything
- Infrastructure can't unilaterally fix it

**The decision trap**:

- Early: "Overcommit 10:1 for efficiency"
- At scale: Platform degrades, but reducing overcommit requires 2x hardware
- Finance rejects budget
- Engineering compensates by scaling out 2x (making problem worse)

### Failure 2: Kubernetes CPU Throttling Cascade

**Scenario**: Team sets conservative CPU limits to "prevent noisy neighbors"

**What breaks**:

- Service hits limits during normal load (GC pause, dependency slowdown)
- Throttling causes request timeouts
- Clients retry failed requests
- Retries cause more CPU usage
- More throttling, more retries → cascade

**Misleading metrics**:

- Node CPU at 60% (plenty of capacity!)
- Container CPU usage "within limits"
- No OOMKills
- Application logs show no errors
- P50 latency fine, P99 is 10x higher

**Actual problem**: `container_cpu_cfs_throttled_seconds_total` climbing, but not in default dashboards

**Why it's hard to reverse**:

- Removing limits entirely risks actual noisy neighbors
- Tuning per-service requires profiling hundreds of services
- "Perfect" limits become wrong in 3 months when load patterns change
- Real fix (proper resource profiling) should have been built Day 1

**The decision trap**:

- Early: "Set conservative limits for safety"
- At scale: Every service throttled, teams request more replicas
- Infrastructure cost 2x, but still throttling
- Removing limits now feels risky because it's the only "protection"

### Failure 3: NUMA Locality Breakdown

**Scenario**: Database migrated from 8-core instance to 16-core instance for "better performance"

**What breaks**:

- 16-core instance has 2 NUMA nodes (2 sockets × 8 cores)
- VM spans both nodes
- vCPUs on Socket 0, memory on Socket 1 (or mixed)
- 50% of memory access becomes remote (1.5-2x slower)
- Throughput drops 30-50%

**Misleading metrics**:

- CPU utilization reasonable
- No steal time
- Memory available
- No swapping

**What matters**: `numastat` shows massive remote memory hits (but only visible from host, not guest)

**Why it's hard to reverse**:

- Downsizing requires downtime
- Application has grown to depend on 16 vCPUs
- Smaller instance seems like "downgrade" to stakeholders
- Proper fix (NUMA-aware VM placement) requires infrastructure changes

### Failure 4: Hyperthreading Contention

**Scenario**: Physical host with HT enabled, compute-heavy workloads

**What breaks**:

- Two tasks land on sibling hyperthreads
- Both doing AVX vector math (sharing FPU)
- Both memory-intensive (sharing L1/L2 cache)
- Each task slows by 30-50%
- Latency becomes unpredictable

**Misleading metrics**:

- All CPUs show 50% busy (looks balanced!)
- Load average reasonable
- No obvious bottleneck

**What matters**: Checking `/sys/devices/system/cpu/cpuX/topology/thread_siblings_list` reveals siblings running
conflicting workloads

**The constraint**:

- Disabling HT cuts advertised capacity 50%
- If you've sold "128 vCPUs per host" based on HT, disabling means evacuating half your VMs
- Triggers capacity crisis and budget fight
- Security issues (Spectre, MDS) may force HT off anyway

### Failure 5: CPU Pinning Anti-Pattern

**Scenario**: Team reads "CPU pinning improves performance," pins all VMs

**What breaks**:

- Pinned CPUs sit idle when VM isn't using them
- Other VMs can't use those CPUs (wasted capacity)
- Poor pinning (vCPUs 0-7 to pCPUs 0-7) spans NUMA nodes
- Worse NUMA locality than auto-placement
- Live migration disabled

**Misleading metrics**:

- vCPUs have "dedicated" pCPUs
- No overcommit
- Clean topology

**What matters**:

- Host CPU utilization becomes unbalanced
- Some pCPUs at 100%, others at 10%
- Total cluster capacity drops 30%

**The over-optimization trap**:

- CPU pinning helps ~5% of workloads (very latency-sensitive, consistent load)
- Teams pin everything "just in case"
- Lose hypervisor flexibility, worse bin-packing, can't live-migrate
- Engineering time spent managing pin configs instead of actual optimization

### Failure 6: Context Switch Explosion

**Scenario**: Application creates too many threads (100 threads on 8 vCPUs)

**What breaks**:

- Kernel spending 50% of time context switching
- Cache thrashing (each switch evicts working set)
- Actual work completed drops despite "high CPU usage"

**Misleading metrics**:

- CPU at 90% utilization
- All cores busy
- Memory fine

**What matters**:

- `vmstat` shows >100k context switches/sec
- Most time in `%sys` (system), not `%us` (user)
- Run queue length (`vmstat r`) >> CPU count

**The wrong fix**: "We need more CPUs!" Adding CPUs makes it worse—more scheduler overhead.

**Right fix**: Reduce thread count to ~vCPU count

### Failure 7: CPU Request/Limit Mismatch

**Scenario**: Pods have `requests.cpu: 100m, limits.cpu: 1000m` (10x spread)

**What breaks**:

- Kubernetes schedules based on requests (node appears to have capacity)
- 20 pods on node, each requesting 100m (2000m total requests)
- All pods burst to limits simultaneously under load (20,000m actual)
- Node is 10x overcommitted
- Massive throttling, health checks fail, pods restart

**Misleading metrics**:

- Node shows 50% CPU available (based on requests)
- Pods under their limits
- No obvious resource exhaustion

**What matters**: Sum of limits >> node capacity when all pods burst

**The design trap**:

- Early: "Set low requests for bin-packing, high limits for bursts"
- At scale: Requests lie to scheduler, actual usage unpredictable
- Should have been: requests ≈ limits, or no limits at all

---

## 5. Production Considerations, Solutions, and Anti-Patterns

### Monitoring and Observability

**Critical metrics often missing from default dashboards**:

```bash
# For VMs - steal time
steal_time_percent > 5%   # Alert on hypervisor contention

# For containers - throttling
container_cpu_cfs_throttled_seconds_total  # Time spent throttled
container_cpu_cfs_periods_total            # Total periods
# Alert when: throttled_periods / total_periods > 10%

# For NUMA systems - remote memory access
numastat | grep "numa_hit" vs "numa_miss"  # On host only

# Context switches
vmstat 1  # Watch 'cs' column, alert > 50k/sec

# Run queue depth
vmstat 1  # Watch 'r' column, alert > 2× CPU count
```

**What to graph for correlation**:

- P99/P999 latency (not average - averages hide throttling spikes)
- Steal time alongside application latency
- Throttle periods alongside request error rate
- Context switches alongside throughput

### VM Sizing Strategy

**Bad approach**:

```
"More vCPUs = better performance"
→ Request 32 vCPUs because why not
→ Span multiple NUMA nodes
→ High scheduler overhead
→ Performance worse than 8 vCPUs
```

**Good approach**:

```
1. Start with 2-4 vCPUs
2. Measure performance at 2, 4, 8, 16
3. Find the knee of the curve (throughput stops increasing)
4. Operate at knee, not maximum
5. Prefer smaller VMs on single NUMA node over large VMs spanning nodes
```

**Steal time management**:

```
If steal > 5% consistently:
  Option 1: Reduce vCPU count (paradoxically can improve performance)
  Option 2: Change instance type to dedicated/less overcommitted
  Option 3: Accept it if cost-sensitive and not latency-sensitive
```

### Container CPU Limit Strategy

**The industry shift**: Many teams removing CPU limits entirely

**Old approach (causing problems)**:

```yaml
resources:
  requests:
    cpu: 100m
  limits:
    cpu: 500m  # Causes throttling
```

**New approach (gaining adoption)**:

```yaml
resources:
  requests:
    cpu: 500m
  # No limits - rely on node capacity
```

**Rationale**:

- CPU is **compressible** (unlike memory - can't OOM from CPU)
- Throttling creates worse experience than temporary contention
- Proper node sizing + requests = natural backpressure
- Limits create artificial freezes even when node has capacity

**If you must use limits**:

```yaml
resources:
  requests:
    cpu: 500m
  limits:
    cpu: 2000m  # 4x headroom for bursts
```

Make limit an "emergency brake," not a normal constraint

### NUMA Awareness

**For VMs**:

- Prefer VM sizes that fit in single NUMA node
- 2 GHz CPU with local memory > 3 GHz CPU with remote memory
- On hypervisor (if accessible): configure NUMA affinity
- Monitor `numastat` on host for remote access patterns

**For containers**:

- Kubernetes 1.18+: topology manager can provide NUMA alignment
- Usually requires CPU manager with static policy
- Only worth it for very specific workloads (databases, caches)

### Hyperthreading Policy

**When to disable HT**:

- Latency-sensitive workloads where variance is unacceptable
- Security-sensitive environments (Spectre, MDS vulnerabilities)
- Compute-bound workloads where siblings conflict (ML training, video encoding)

**When to keep HT**:

- Throughput-oriented workloads with diverse instruction mix
- I/O-bound workloads (web servers waiting on network/disk)
- Cost-sensitive environments where capacity reduction is unacceptable

**The hard choice**: Can't please everyone with one policy. May need different host pools.

### Thread Pool Sizing

**The common mistake**:

```java
// "More threads = better parallelism"
ExecutorService pool = Executors.newFixedThreadPool(100);
// On 8 vCPU system → context switch explosion
```

**The right approach**:

```java
// Start with vCPU count
int cpus = Runtime.getRuntime().availableProcessors();
ExecutorService pool = Executors.newFixedThreadPool(cpus);

// For I/O-bound: cpus * (1 + wait_time/compute_time)
// For CPU-bound: cpus
```

**For containers**: `availableProcessors()` returns host CPU count, not limit. Need to read cgroup quota manually.

---

### Anti-Patterns and Red Flags

**"The hypervisor/scheduler will handle it"**

❌ Why risky: Hypervisor optimizes for fairness and utilization, not your latency SLO. When overcommitted, fairly
distributes CPU starvation across all VMs.

✅ Instead: Monitor steal time, set SLOs on it, size VMs appropriately

---

**"We've never seen steal time above 5% before"**

❌ Why risky: Absence of historical problems doesn't mean system can't enter that state. Steal time appears when workload
patterns change (traffic spikes, new batch jobs, neighbors scaling).

✅ Instead: Load test under worst-case scenarios (all VMs active)

---

**"CPU limits prevent noisy neighbors"**

❌ Why risky: Limits create throttling, which can make noisy neighbors worse. Throttled container wakes up frequently,
burns scheduler time, pollutes caches.

✅ Instead: Use requests for scheduling, monitor actual usage, use node affinity/taints for workload separation

---

**"More vCPUs = better performance"**

❌ Why risky: Beyond a certain point, more vCPUs = more scheduler overhead, more cache misses, more NUMA remote access.

✅ Instead: Benchmark at 2, 4, 8, 16 vCPUs. Operate at knee of curve.

---

**"The cloud provider guarantees this vCPU performance"**

❌ Why risky: Providers guarantee minimum performance, not consistent performance. Steal time can still occur. HT vs
dedicated cores often unspecified.

✅ Instead: Read the fine print. "Dedicated vCPUs" often means "not shared with other tenants' VMs" but might still be
hyperthreads.

---

**"Pinning CPUs always improves performance"**

❌ Why risky: Pinning trades flexibility for determinism. Wrong pinning (spanning NUMA nodes) makes performance worse.
Prevents live migration.

✅ Instead: Only pin for specific latency-critical workloads after measuring benefit

---

**"We tuned the CPU limit perfectly, so we're done"**

❌ Why risky: Workload changes. Dependencies change. "Perfect" limit becomes wrong in 3 months.

✅ Instead: Build autoscaling, load shedding, graceful degradation. Make system resilient to contention, not dependent on
perfect limits.

---

## 6. Socratic Questions

1. If your VM has 4 vCPUs and the hypervisor has 8 pCPUs, what happens when all VMs on the host try to use their vCPUs
   simultaneously? What breaks first—throughput or latency?

2. A container with `cpu: 1000m` limit sometimes completes requests faster than a container with `cpu: 500m` limit, even
   though the first one should be throttled more. How is this possible?

3. If you see 70% CPU usage inside a VM but the application is slow, what are three different layers where the problem
   could be hiding?

4. A Kubernetes pod has `requests.cpu: 100m` and `limits.cpu: 1000m`. Under what conditions does this configuration make
   your cluster less stable than having `requests: 500m, limits: 500m`?

5. Why might 2 vCPUs pinned to 2 pCPUs on the same NUMA node outperform 8 vCPUs with no pinning? What assumptions about
   the workload must be true?

6. If you disable hyperthreading, you cut your CPU count from 128 to 64. Under what circumstances does this increase
   total cluster throughput?

7. What happens to CPU cache coherency traffic when a multi-threaded application's threads migrate across NUMA nodes?
   Which layer sees this cost, and which metrics measure it?

8. A VM shows 5% steal time. Is this bad? What's the first thing you'd check to determine if this is causing
   user-visible impact?

9. Why does adding more worker threads to a CPU-bound application sometimes make it slower, even when CPU usage is only
   60%?

10. Your container is throttled 30% of periods but CPU usage shows only 40% of limit. How can it be throttled if it's
    not hitting the limit?

---

## 7. Key Insights for Application Developers

*This section translates infrastructure concepts into actionable guidance for developers without deep systems
knowledge.*

### What "CPU" Really Means

**When you see "8 CPUs" in a VM or container:**

- It doesn't mean 8 independent processors
- Might be 4 real cores with hyperthreading (sharing execution units)
- Might be 8 virtual CPUs sharing 2 physical cores with other VMs
- Might be 8 CPUs you can see but can only use 0.5 of them (throttling)

**Practical impact**: Don't assume "8 CPUs = 8x parallelism." More threads can make your app slower.

### Why Your App Is Slow When CPU Looks Fine

**Scenario**: Dashboard shows 30% CPU usage, but requests take 3x longer than normal.

**What's really happening** (one of these):

1. **Steal time**: Your VM is waiting in a queue at the hypervisor level. It's like your server is running in slow
   motion, but can't see why.

2. **Throttling**: Your container exhausted its quota and is frozen. It's like your server pauses for 50ms every 100ms,
   even though it has work to do.

3. **NUMA remote access**: Your code is running on Socket 0 but all your data is in Socket 1's memory. Every memory
   access takes 2x longer.

4. **Cache thrashing**: You have 100 threads on 8 CPUs. They keep evicting each other's data from cache, causing memory
   stalls.

**What to check**:

```bash
# In a VM - check steal time
top
# Look for %st (steal time) in CPU line
# If > 5%, your VM is waiting for physical CPU

# In a container - check throttling
kubectl get pod my-app -o json | \
  jq '.status.containerStatuses[0].state'
# Or check container_cpu_cfs_throttled_seconds_total metric

# General - check context switches
vmstat 1
# If 'cs' (context switches) > 50,000/sec, too many threads
```

### Thread Pool Sizing: The Most Common Mistake

**Don't do this**:

```python
# "More threads = faster"
thread_pool = ThreadPoolExecutor(max_workers=200)
```

On an 8 CPU system, 200 threads means:

- Kernel spending 50% of time switching between threads
- Each thread runs for 1ms, then waits 24ms for its turn
- Cache is constantly evicted and reloaded
- Your "200 threads" are slower than 8 threads would be

**Do this**:

```python
import os
cpu_count = os.cpu_count()  # Returns 8

# For CPU-bound work
thread_pool = ThreadPoolExecutor(max_workers=cpu_count)

# For I/O-bound work (waiting on network/disk)
thread_pool = ThreadPoolExecutor(max_workers=cpu_count * 4)
```

**Warning for containers**: `os.cpu_count()` returns the host's CPU count, not your container's limit. You might see "64
CPUs" but only have a 500m limit (0.5 CPU). Need to read cgroup quota manually or use container-aware libraries.

### Understanding CPU Limits in Kubernetes

**What you think happens**:

```yaml
resources:
  limits:
    cpu: 500m  # "0.5 CPU"
```

"My app can use up to 50% of one CPU, and it'll just slow down if it wants more."

**What actually happens**:

The system gives your container 50ms of CPU time every 100ms. If you use it up in the first 50ms:

- Remaining 50ms: Your container is FROZEN (0% CPU)
- Even if the server has idle CPU
- Requests in progress are paused mid-execution

**This is why you see random 100ms latency spikes** even though "CPU looks fine."

**Better approach**:

```yaml
resources:
  requests:
    cpu: 500m
  # No limit, or limit: 2000m (4x headroom)
```

### What to Do When Performance Is Bad

**1. Check if you're being throttled (containers)**

```bash
kubectl describe pod my-app | grep -i throttl
# or
kubectl get --raw "/apis/metrics.k8s.io/v1beta1/namespaces/default/pods/my-app" | jq
```

If throttled → either increase limit or reduce actual usage

**2. Check steal time (VMs)**

```bash
top  # Look at %st
# or
mpstat 1  # Shows per-CPU steal time
```

If steal > 5% → your VM is waiting for physical CPU. Either:

- Reduce vCPU count (counterintuitive but can help)
- Move to less overcommitted instance type
- Accept it if cost-sensitive

**3. Check context switches**

```bash
vmstat 1
# Watch 'cs' column
```

If > 50k/sec → reduce thread count in your application

**4. Check if you're I/O bound**

```bash
top  # Look at %wa (I/O wait)
iostat -x 1  # Disk stats
```

If high %wa → problem is disk/network, not CPU. Adding CPU won't help.

### Designing for CPU Contention

**Don't**:

- Create one thread per request (unbounded threads)
- Assume CPU limits are soft (they're hard freezes)
- Ignore performance variance (P99 latency matters more than average)
- Set tiny CPU limits "just to be safe"

**Do**:

- Use bounded thread pools sized to available CPUs
- Add timeouts and circuit breakers (assume latency will spike)
- Monitor P99/P999 latency, not just average
- Either set generous CPU limits (4x normal usage) or no limits at all
- Handle SIGTERM gracefully (throttled apps often get killed by health checks)

### The Most Important Insight

**CPU is not like memory.**

Memory:

- You request 1 GB, you get 1 GB
- If you exceed, you OOM (clear failure)
- Measurements are accurate

CPU:

- You request "1 CPU" but what you get depends on:
    - Hypervisor overcommit (steal time)
    - Hyperthreading siblings (sharing execution units)
    - NUMA placement (2x memory latency penalty)
    - Container throttling (hard freezes)
- You can be "within limits" but still frozen
- Standard metrics hide the real bottlenecks

**Action**: Build resilience to CPU contention into your application (timeouts, retries with backoff, circuit breakers)
rather than assuming CPU will always be available when needed.
