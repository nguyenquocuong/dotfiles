# Kubernetes Operations

Debugging and operating workloads. Organized by symptom because that's how problems arrive.

## Workload debugging by symptom

**Pod Pending** — scheduler can't place it. `kubectl describe pod` → Events section says why. Usual suspects: insufficient CPU/memory on nodes (check requests vs `kubectl describe nodes` allocatable), unsatisfiable nodeSelector/affinity/taints, PVC unbound (check the PVC and its StorageClass), or hitting a ResourceQuota.

**CrashLoopBackOff** — container starts and dies repeatedly. `kubectl logs <pod> --previous` (the current logs are the *new* attempt; `--previous` shows why the last one died). If logs are empty: `kubectl describe pod` for exit code. Exit 137 = OOMKilled or SIGKILL (check `lastState.terminated.reason`); exit 1 = app error; exit 0 in a loop = the container's command finishes and K8s restarts it (wrong `command`/process not foregrounded). Failing liveness probes also cause restart loops that look identical — check Events.

**ImagePullBackOff** — wrong image name/tag, private registry without imagePullSecrets, or rate-limited (Docker Hub). Events section has the exact registry error.

**Pod Running but service broken** — work the chain: does the Service have endpoints (`kubectl get endpoints <svc>` — empty means the selector doesn't match pod labels, the #1 cause)? Do readiness probes pass (unready pods are removed from endpoints)? Does the targetPort match the containerPort? Can you reach the pod directly (`kubectl port-forward` to the pod, then to the service — bisects the problem)? NetworkPolicy blocking traffic?

**OOMKilled** — limit too low, or a real leak. Check `kubectl top pod` trend vs the limit. Raising the limit is a mitigation, not a fix, if usage grows unbounded.

**Node NotReady** — `kubectl describe node`: kubelet stopped posting status, disk/memory/PID pressure, or network partition. Workloads get evicted after ~5m; check whether the node recovered or needs replacing.

## Reading the cluster

- `kubectl get events -A --sort-by=.lastTimestamp | tail -30` — the cluster's own account of what's going wrong; check it early, it's free.
- `kubectl get pods -A -o wide | grep -vE 'Running|Completed'` — everything unhealthy at a glance.
- `kubectl rollout history deployment/<x>` and `kubectl diff -f <manifest>` — what changed.
- `kubectl auth can-i <verb> <resource> --as system:serviceaccount:<ns>:<sa>` — RBAC debugging without trial-and-error.

## Resource management principles

- **Requests are for the scheduler, limits are for the kernel.** Requests too low → node overcommit and noisy-neighbor evictions. Memory limit too low → OOMKills. CPU limits cause throttling even with idle CPU on the node — many teams set memory limits but no CPU limits, which is a defensible default.
- **Always set requests** on production workloads. Pods without requests are BestEffort QoS — first to be evicted under pressure.
- **Memory limit = memory request** (Guaranteed-ish for memory) is a common sane default: memory isn't compressible, so overcommitting it turns pressure into OOMKills.
- PodDisruptionBudgets for anything where "all replicas gone at once" hurts — node drains and cluster upgrades honor them.

## Rollouts

- Deployment default is rolling update; tune `maxUnavailable`/`maxSurge` when capacity is tight.
- `kubectl rollout undo` is the fast rollback; it flips to the previous ReplicaSet, which still exists — near-instant, no image pull.
- Probes drive rollout safety: a deploy with no readiness probe reports "successful" the moment containers start, broken or not. Readiness gates traffic; liveness restarts wedged processes (and does *not* belong on slow-starting apps without a startupProbe — it kills them mid-boot).
- Helm: `helm diff upgrade` (plugin) before `helm upgrade`; `helm rollback <release> <rev>` to revert; `helm get values <release>` to see what's actually deployed vs what the values file says.

## Security posture quick wins

For deeper review checklists see `security-review.md`. Operationally, the highest-leverage settings on any workload: `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, `readOnlyRootFilesystem: true` where the app tolerates it, drop all capabilities and add back only what's needed, no `hostNetwork`/`hostPID`/`hostPath` without a strong reason, and a dedicated ServiceAccount with `automountServiceAccountToken: false` unless the pod actually talks to the API server.
