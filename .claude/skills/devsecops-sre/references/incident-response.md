# Incident Response

The triage loop for "something is broken in production". The point of the structure is to keep you from tunnel-visioning on the first interesting anomaly — most wasted incident time comes from debugging something that turns out to be a symptom, not a cause.

## Phase 0: Establish impact (first 2 minutes)

Before any debugging, answer:

- **What is actually broken from the user's perspective?** "API returning 500s" is different from "API slow" is different from "one endpoint failing". Get the symptom precise.
- **How broad?** All users or some? All regions/AZs? All requests or a percentage? `kubectl get pods -A | grep -v Running`, load balancer metrics, error-rate dashboards.
- **Since when?** The start time is the single most valuable clue, because the next question is:
- **What changed?** Deploys, config changes, certificate expiries, scaling events, upstream provider incidents. `kubectl rollout history`, recent merges to main, `terraform state` timestamps, cloud provider status pages. The majority of incidents are caused by a change someone made — check this before exotic theories.

If impact is severe and a recent deploy correlates with the start time, **propose the rollback now**, before deeper diagnosis. Say it explicitly: "Deploy at 14:32, errors start 14:33 — I'd roll back first and diagnose after. Command: `kubectl rollout undo deployment/X`. Approve?"

## Phase 1: Gather signals

Work the layers top-down and write down what you find (a running timeline in the chat or a scratch file — it becomes the postmortem):

1. **Entry point**: LB/ingress error rates and latency. Distinguishes "backend broken" from "backend unreachable".
2. **Workload**: `kubectl get pods` (restarts? OOMKilled? Pending?), `kubectl describe` on suspects, `kubectl logs --previous` for crashed containers.
3. **Dependencies**: database connections/latency, cache hit rates, third-party API status, DNS resolution. A healthy service with a sick dependency looks sick itself.
4. **Platform**: node status, cluster events (`kubectl get events -A --sort-by=.lastTimestamp | tail -30`), cloud provider health, disk/memory pressure, certificate expiry.

Signals to trust over intuition: error messages in logs (read them fully — the answer is often literally printed), resource saturation graphs, and correlation with the change timeline.

## Phase 2: Hypothesize and test

State hypotheses explicitly, ranked by likelihood, and identify the cheapest read-only test that discriminates between them. "If it's connection-pool exhaustion, active connections in the DB will be pinned at max — checking that" beats trying fixes.

Common failure patterns worth checking early because they're frequent and fast to confirm:

- **Bad deploy** → correlate timing, rollback
- **Resource exhaustion** → OOMKilled in pod status, CPU throttling, disk full, connection pools, file descriptors
- **Certificate/secret expiry** → TLS errors in logs, exactly-N-days-after-issuance timing
- **DNS** → intermittent, weird, cross-service failures; `dig` from inside a pod, not just your laptop
- **Thundering herd / retry storm** → traffic graph shows amplification after a small initial blip
- **Upstream provider** → check status pages before spending an hour proving it's not you

## Phase 3: Mitigate

Prefer mitigations in this order — fastest and most reversible first:

1. **Rollback** the correlated change
2. **Scale up / restart** if it's resource pressure or a wedged process (know that restarts destroy evidence — grab logs/heap dumps first if cheap to do)
3. **Feature-flag off / disable** the failing path
4. **Shed load** (rate-limit, maintenance page for a subset) to keep the core alive
5. **Fix forward** — only when rollback is impossible or the fix is genuinely trivial

Every mitigation is a mutation: state blast radius, get approval, verify recovery afterward with the same signals that showed the problem (error rate back to baseline, not just "pods are Running").

## Phase 4: Aftermath

- Confirm stability for long enough to trust it (a retry storm can resurge).
- Root-cause now that pressure is off — the mitigation usually points at it.
- Offer the blameless postmortem: impact summary, timeline (from your running notes), root cause, contributing factors, action items each with an owner-shaped description. Contributing factors matter more than the trigger: "the bad config was the trigger; no config validation in CI and no canary stage let it reach 100% of prod" is where the action items live.
