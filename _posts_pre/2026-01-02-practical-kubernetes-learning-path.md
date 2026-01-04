---
title: "A Practical Learning Path for Kubernetes: From Core Concepts to Production"
date: 2026-01-02 00:00:01 -0500
categories: kubernetes
tags: [kubernetes, k8s, devops, infrastructure, learning-path]
---

As an application developer who has dabbled with Kubernetes but wants to go deeper, I've put together this learning path. This guide takes you from understanding core concepts through the codebase to handling production disasters. The goal isn't just to deploy applications, but to understand what's happening under the hood and be ready for production challenges.

## Phase 1: Core Concepts with Code-Level Understanding

### Understanding the Control Plane (Week 1-2)

Start by understanding that Kubernetes is fundamentally about **desired state reconciliation**. The control plane constantly works to make the actual state match your declared desired state.

**Key Components to Study:**

1. **API Server (`kube-apiserver`)**
   - Entry point for all REST commands
   - Study: `kubernetes/cmd/kube-apiserver/app/server.go`
   - Key insight: Everything goes through the API server, which stores state in etcd
   - **Hands-on**: Use `kubectl --v=9` to see the actual API calls being made

2. **Controller Manager (`kube-controller-manager`)**
   - Runs controllers that watch resources and reconcile state
   - Study: `kubernetes/pkg/controller/` directory
   - Pick one controller to understand deeply: ReplicaSet controller is a good start
   - **Hands-on**: Watch controller behavior with `kubectl get events --watch`

3. **Scheduler (`kube-scheduler`)**
   - Assigns pods to nodes based on constraints and available resources
   - Study: `kubernetes/pkg/scheduler/` for the scheduling algorithm
   - **Hands-on**: Create pods with different resource requests and node affinities to see scheduling decisions

4. **etcd**
   - The distributed key-value store holding cluster state
   - Study: How to interact with etcd directly using `etcdctl`
   - **Hands-on**: Backup and restore etcd, examine stored objects

**Deep Dive Exercise:**

```bash
# Start a local Kubernetes cluster with kind
kind create cluster --name learning

# Deploy a simple app
kubectl create deployment nginx --image=nginx --replicas=3

# Watch the reconciliation loop in action
kubectl get events --watch &
kubectl delete pod <pod-name>  # Watch it get recreated
```

Read the code for the ReplicaSet controller to understand how it detects and fixes the missing pod.

### Understanding the Data Plane (Week 3-4)

The data plane is where your applications actually run. Understanding this is critical for debugging production issues.

**Key Components:**

1. **kubelet**
   - The agent running on each node
   - Manages pod lifecycle and reports node status
   - Study: `kubernetes/pkg/kubelet/`
   - Focus on: Container runtime interface (CRI), pod lifecycle management

2. **Container Runtime (containerd/CRI-O)**
   - Actually runs your containers
   - Understand the CRI interface in `kubernetes/pkg/kubelet/cri/`
   - **Hands-on**: Use `crictl` to interact with the container runtime directly

3. **kube-proxy**
   - Implements Service abstraction through iptables/IPVS
   - Study: `kubernetes/pkg/proxy/` for networking rules
   - **Hands-on**: Examine iptables rules created by kube-proxy

**Deep Dive Exercise:**

```bash
# SSH into a node (or use docker exec with kind)
docker exec -it learning-control-plane bash

# Examine kubelet logs
journalctl -u kubelet -f

# Look at container runtime
crictl ps
crictl logs <container-id>

# Examine networking rules
iptables -t nat -L KUBE-SERVICES
```

Study how a request to a Service IP gets routed to a pod IP.

## Phase 2: Advanced Technologies Applied to Kubernetes

### Custom Resource Definitions (CRDs) and Operators (Week 5-6)

CRDs extend Kubernetes with custom objects. Operators use controllers to manage these custom resources.

**Learn by Building:**

Create a simple operator that manages a custom "WebApp" resource:

```yaml
apiVersion: myapp.io/v1
kind: WebApp
metadata:
  name: my-webapp
spec:
  replicas: 3
  image: nginx:latest
  domain: example.com
```

Your operator should:

- Create a Deployment for the webapp
- Create a Service
- Create an Ingress with the specified domain

**Resources:**

- Use [kubebuilder](https://github.com/kubernetes-sigs/kubebuilder) to scaffold the operator
- Study existing operators like [prometheus-operator](https://github.com/prometheus-operator/prometheus-operator)
- Read: `kubernetes/staging/src/k8s.io/apiextensions-apiserver/` to understand CRD implementation

**Hands-on Project:**

```bash
# Initialize operator project
kubebuilder init --domain myapp.io --repo github.com/yourname/webapp-operator
kubebuilder create api --group myapp --version v1 --kind WebApp

# Implement reconciliation logic
# Test on local cluster
make install
make run
```

### Service Mesh and Advanced Networking (Week 7-8)

Service meshes add observability, security, and reliability to service-to-service communication.

**Deep Dive into Istio:**

1. **Architecture Understanding:**
   - Control plane: istiod (combines Pilot, Citadel, Galley)
   - Data plane: Envoy sidecars
   - Study: How Envoy configs are generated and pushed to sidecars

2. **Core Features:**
   - Traffic management: routing rules, retries, timeouts
   - Security: mTLS between services
   - Observability: distributed tracing, metrics

**Hands-on:**

```bash
# Install Istio
istioctl install --set profile=demo

# Deploy sample application
kubectl label namespace default istio-injection=enabled
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml

# Experiment with traffic routing
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:
  - reviews
  http:
  - match:
    - headers:
        end-user:
          exact: jason
    route:
    - destination:
        host: reviews
        subset: v2
  - route:
    - destination:
        host: reviews
        subset: v1
EOF
```

Study Envoy configuration generated by Istio: `istioctl proxy-config routes <pod-name>`

### Storage and StatefulSets (Week 9)

Understanding persistent storage is crucial for stateful applications.

**Core Concepts:**

1. **Persistent Volumes (PV) and Persistent Volume Claims (PVC)**
2. **Storage Classes** for dynamic provisioning
3. **StatefulSets** for stateful applications
4. **CSI (Container Storage Interface)** drivers

**Study:**

- Look at `kubernetes/pkg/volume/` for volume plugin implementation
- Understand CSI specification and how drivers work

**Hands-on Project - Deploy a Stateful Application:**

```bash
# Create a StatefulSet running PostgreSQL
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:14
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi
EOF
```

Observe:

- How StatefulSet creates pods with stable network identities
- How each pod gets its own PVC
- Pod restart behavior with persistent data

## Phase 3: Production-Ready Environments

### Infrastructure as Code (Week 10-11)

Production clusters should be reproducible and version-controlled.

**Tools to Master:**

1. **Terraform for Infrastructure:**

```hcl
# Example: EKS cluster on AWS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "production"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    main = {
      desired_size = 3
      min_size     = 3
      max_size     = 10

      instance_types = ["m5.xlarge"]
      capacity_type  = "ON_DEMAND"
    }
  }
}
```

1. **GitOps with ArgoCD or Flux:**

```yaml
# ArgoCD Application
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/yourorg/k8s-manifests
    targetRevision: HEAD
    path: production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

**Hands-on:**

1. Set up a complete production-ready cluster with Terraform
2. Implement GitOps workflow with ArgoCD
3. Practice deploying and rolling back applications through Git commits

### Security and Access Control (Week 12)

Production requires robust security.

**Key Areas:**

1. **RBAC (Role-Based Access Control):**

   ```yaml
   # Example: Developer role
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
     namespace: development
     name: developer
   rules:
   - apiGroups: ["", "apps", "batch"]
     resources: ["pods", "deployments", "jobs"]
     verbs: ["get", "list", "watch", "create", "update", "delete"]
   - apiGroups: [""]
     resources: ["pods/log"]
     verbs: ["get", "list"]
   ```

2. **Pod Security Standards:**
   - Implement Pod Security Admission
   - Use security contexts to enforce least privilege

3. **Network Policies:**

   ```yaml
   apiVersion: networking.k8s.io/v1
   kind: NetworkPolicy
   metadata:
     name: api-allow-ingress
   spec:
     podSelector:
       matchLabels:
         app: api
     policyTypes:
     - Ingress
     ingress:
     - from:
       - podSelector:
           matchLabels:
             app: frontend
       ports:
       - protocol: TCP
         port: 8080
   ```

4. **Secrets Management:**
   - Use external secrets operators (e.g., External Secrets Operator with AWS Secrets Manager)
   - Never commit secrets to Git

**Hands-on:**

1. Set up RBAC for different team roles
2. Implement network policies to segment workloads
3. Configure external secrets management

### Observability (Week 13)

You can't manage what you can't measure.

**Stack Setup:**

1. **Metrics: Prometheus + Grafana**

   ```bash
   # Install kube-prometheus-stack
   helm install prometheus prometheus-community/kube-prometheus-stack \
     --namespace monitoring --create-namespace
   ```

2. **Logging: Loki or ELK**

   ```bash
   # Install Loki stack
   helm install loki grafana/loki-stack \
     --namespace monitoring \
     --set grafana.enabled=true
   ```

3. **Tracing: Jaeger or Tempo**

4. **Key Metrics to Monitor:**
   - Cluster: CPU, memory, disk usage per node
   - Application: Request rate, error rate, duration (RED metrics)
   - Saturation: Queue depths, thread pool usage
   - Kubernetes-specific: Pod restart count, container OOM kills

**Hands-on:**

1. Set up complete observability stack
2. Create dashboards for your applications
3. Set up alerts for critical conditions
4. Practice debugging issues using metrics, logs, and traces together

### Resource Management and Auto-scaling (Week 14)

Efficient resource usage is critical for cost and reliability.

**Core Concepts:**

1. **Resource Requests and Limits:**

   ```yaml
   resources:
     requests:
       memory: "128Mi"
       cpu: "100m"
     limits:
       memory: "256Mi"
       cpu: "500m"
   ```

2. **Horizontal Pod Autoscaler (HPA):**

   ```yaml
   apiVersion: autoscaling/v2
   kind: HorizontalPodAutoscaler
   metadata:
     name: api-hpa
   spec:
     scaleTargetRef:
       apiVersion: apps/v1
       kind: Deployment
       name: api
     minReplicas: 3
     maxReplicas: 10
     metrics:
     - type: Resource
       resource:
         name: cpu
         target:
           type: Utilization
           averageUtilization: 70
   ```

3. **Vertical Pod Autoscaler (VPA):** Automatically adjusts resource requests
4. **Cluster Autoscaler:** Adds/removes nodes based on pod scheduling needs

**Hands-on:**

1. Right-size applications using VPA recommendations
2. Implement HPA based on custom metrics (e.g., queue depth)
3. Test cluster autoscaler by creating resource pressure

## Phase 4: Disaster Recovery and Incident Response

### Backup and Restore Strategies (Week 15)

**What to Backup:**

1. **etcd snapshots** (cluster state)
2. **Persistent volume data** (application data)
3. **Configuration** (stored in Git via GitOps)

**Tools:**

1. **Velero for Kubernetes Backups:**

   ```bash
   # Install Velero
   velero install \
     --provider aws \
     --plugins velero/velero-plugin-for-aws:v1.8.0 \
     --bucket velero-backups \
     --backup-location-config region=us-west-2
   
   # Create backup
   velero backup create production-backup --include-namespaces production
   
   # Schedule regular backups
   velero schedule create daily-backup --schedule="0 2 * * *"
   
   # Restore from backup
   velero restore create --from-backup production-backup
   ```

2. **etcd Snapshot:**

   ```bash
   # Take snapshot
   ETCDCTL_API=3 etcdctl snapshot save snapshot.db \
     --endpoints=https://127.0.0.1:2379 \
     --cacert=/etc/kubernetes/pki/etcd/ca.crt \
     --cert=/etc/kubernetes/pki/etcd/server.crt \
     --key=/etc/kubernetes/pki/etcd/server.key
   
   # Restore from snapshot
   ETCDCTL_API=3 etcdctl snapshot restore snapshot.db \
     --data-dir=/var/lib/etcd-from-backup
   ```

**Hands-on:**

1. Set up automated backups with Velero
2. Practice disaster scenarios: delete a namespace and restore it
3. Document recovery procedures and test them regularly

### Disaster Scenarios and Recovery (Week 16)

**Common Production Disasters:**

1. **Control Plane Failure:**
   - Symptoms: Cannot create/modify resources
   - Recovery: Restore etcd from backup, restart control plane components
   - Prevention: Multi-master setup, regular etcd backups

2. **Node Failure:**
   - Symptoms: Pods on node become unavailable
   - Recovery: Cluster autoscaler or manual node replacement
   - Prevention: Pod Disruption Budgets, proper health checks

3. **Application Failure:**
   - Symptoms: Pods crashing, high error rates
   - Recovery: Rollback deployment, investigate logs
   - Prevention: Proper liveness/readiness probes, gradual rollouts

4. **Resource Exhaustion:**
   - Symptoms: Pod evictions, scheduling failures
   - Recovery: Scale up nodes, adjust resource requests
   - Prevention: Resource quotas, monitoring, autoscaling

5. **Data Corruption:**
   - Symptoms: Application errors, inconsistent state
   - Recovery: Restore from Velero backup or PV snapshots
   - Prevention: Regular backups, test restores

**Hands-on Chaos Engineering:**

Use tools like Chaos Mesh or Litmus to inject failures:

```bash
# Install Chaos Mesh
helm install chaos-mesh chaos-mesh/chaos-mesh \
  --namespace chaos-mesh --create-namespace

# Inject pod failure
kubectl apply -f - <<EOF
apiVersion: chaos-mesh.org/v1alpha1
kind: PodChaos
metadata:
  name: pod-failure
spec:
  action: pod-failure
  mode: one
  selector:
    namespaces:
      - production
    labelSelectors:
      app: api
  scheduler:
    cron: '@every 2m'
EOF
```

Practice responding to:

- Random pod deletions
- Network latency between services
- CPU/memory stress on nodes
- Partition scenarios

### Incident Response Playbook

**Template for Each Disaster Type:**

1. **Detection:** How do you know this happened? (alerts, symptoms)
2. **Triage:** Quick checks to determine severity and root cause
3. **Immediate Actions:** Steps to restore service quickly
4. **Investigation:** Deeper analysis to prevent recurrence
5. **Communication:** Who to notify, status updates
6. **Post-Mortem:** Document what happened and improvements

#### Example: Deployment Rollout Failure

```bash
# 1. Detection: High error rates in monitoring

# 2. Triage
kubectl get deployments
kubectl describe deployment api
kubectl get events --sort-by=.metadata.creationTimestamp

# 3. Immediate Action - Rollback
kubectl rollout undo deployment/api
kubectl rollout status deployment/api

# 4. Investigation
kubectl logs -l app=api --previous  # Check failed pod logs
kubectl describe pod <failed-pod>

# 5. Fix and gradual rollout
kubectl patch deployment api -p '{"spec":{"strategy":{"type":"RollingUpdate","rollingUpdate":{"maxSurge":1,"maxUnavailable":0}}}}'
```

## Learning Resources

**Official Documentation:**

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Kubernetes Source Code](https://github.com/kubernetes/kubernetes)

**Books:**

- "Kubernetes in Action" by Marko Lukša (comprehensive overview)
- "Programming Kubernetes" by Michael Hausenblas (for operator development)
- "Production Kubernetes" by Josh Rosso (operations focus)

**Hands-on Platforms:**

- [Killercoda](https://killercoda.com/) - Interactive scenarios
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) - Build from scratch

**Community:**

- Join Kubernetes Slack
- Contribute to Kubernetes SIGs (Special Interest Groups)
- Attend KubeCon or local meetups

## Next Steps

This 16-week path provides a structured approach to mastering Kubernetes. However, learning is not linear. You'll likely iterate between phases as you encounter real problems. The key is:

1. **Build mental models** by reading code and understanding "why" decisions were made
2. **Practice deliberately** with hands-on exercises, not just reading
3. **Break things intentionally** to understand failure modes
4. **Run production workloads** (even if it's a side project) to experience real operational challenges

Start with a specific project that requires Kubernetes, and work through this learning path as you build it. The combination of structured learning and practical application will make the concepts stick.

What's your first step? Pick a project, spin up a cluster, and start exploring.
