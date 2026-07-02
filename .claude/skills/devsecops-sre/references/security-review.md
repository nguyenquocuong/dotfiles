# Security Review Checklists

Per-artifact checklists for reviewing configs. Two rules for reporting that matter more than any individual check:

1. **Order by severity and say why.** "Will get you breached" (exposed secret, public admin endpoint, RCE-shaped pipeline) ≠ "hardening" (missing readOnlyRootFilesystem) ≠ "polish" (layer-count optimizations). A finding's write-up: what it is → how it gets exploited or fails → the concrete fix as corrected config, not prose.
2. **Read the artifact's context before judging.** A `hostPath` mount is a critical finding on an internet-facing app and table stakes for a log collector DaemonSet. Ask (or infer and state the assumption) what the thing is *for*.

## Dockerfile

- **Runs as root?** No `USER` directive means root; combined with a writable filesystem and a docker.sock mount somewhere, that's container escape territory. Fix: create and switch to a non-root user.
- **Secrets in layers**: `COPY .env`, `ARG TOKEN` used in a `RUN` (ends up in layer metadata), git credentials for private repos. Layers are forever — even a later `rm` leaves the secret in the earlier layer. Fix: BuildKit `--mount=type=secret`, or fetch at runtime.
- **Base image**: unpinned tags (`FROM node:latest`) make builds non-reproducible; huge bases carry huge CVE surface. Prefer slim/distroless, pin to digest for prod, and have a rebuild cadence (a pinned image never self-patches).
- `ADD` with URLs (no checksum verification) vs `COPY`; `curl | bash` installs; packages installed without version pins when reproducibility matters.
- Multi-stage builds so compilers/build tools don't ship to prod; `.dockerignore` covering `.git`, `.env`, keys.
- HEALTHCHECK present for anything an orchestrator won't probe externally.

## Kubernetes manifests

Severity-ordered:

- **Privileged / host access**: `privileged: true`, `hostNetwork`, `hostPID`, `hostPath` mounts (especially docker.sock), `CAP_SYS_ADMIN`. Each is near-node-takeover if the pod is compromised; each needs an explicit justification.
- **Secrets handling**: secrets as env vars leak via `/proc`, crash dumps, and child processes — volume mounts are better; secrets committed in manifests are findings regardless of base64 ("encoding is not encryption"); external-secrets/sealed-secrets/SOPS for the git story.
- **ServiceAccount**: default SA with `automountServiceAccountToken` on gives every pod an API credential it probably doesn't need. Dedicated SA per workload, automount off unless used, RBAC scoped to what it does.
- **SecurityContext baseline**: `runAsNonRoot: true`, `allowPrivilegeEscalation: false`, `capabilities: {drop: [ALL]}`, `seccompProfile: RuntimeDefault`, `readOnlyRootFilesystem: true` where tolerable. Absence of all of these = pod runs as root by whatever the image says.
- **No resource limits/requests** → one workload can starve the node (availability finding, not just perf).
- **NetworkPolicy absent** → flat network; any pod reaches any pod including the database. At minimum, default-deny ingress in sensitive namespaces plus explicit allows.
- Probes present and *different* (a liveness probe identical to readiness on a dependency-checking endpoint turns a dependency blip into a restart storm); image tags pinned (`:latest` on prod is a rollback and provenance problem); PodDisruptionBudget for HA claims.

## CI/CD workflow files (GitHub Actions / GitLab CI)

- **Untrusted-code-with-secrets**: `pull_request_target` (or GitLab equivalent) checking out and running PR head code — the classic pipeline RCE. Also: workflows that run on fork PRs with secrets available.
- **Unpinned third-party actions** (`@v3`, `@main` instead of a SHA) — supply-chain trust in a mutable ref, with your secrets in env.
- **Token scope**: no explicit `permissions:` block (default is broad), `GITHUB_TOKEN` with write-all doing a read-only job, deploy creds not scoped per environment, prod environment without required reviewers.
- **Injection**: `${{ github.event.*.title }}` and other attacker-controlled fields interpolated into `run:` scripts — shell injection. Fix: pass via `env:` and quote.
- Long-lived cloud keys in secrets where OIDC federation would do; `set -x`/verbose flags echoing secrets into logs; artifacts/caches shared across trust boundaries (a poisoned cache from a PR restored in a main build).

## Terraform / IaC

- **State security first** (most-missed): state contains plaintext secrets; backend must be encrypted, versioned, access-controlled. Local state committed to git is a critical finding.
- **Overly-broad IAM in code**: `"Action": "*"`, `"Resource": "*"`, `iam:PassRole` unscoped (privilege-escalation primitive), inline policies nobody reviews.
- **Public exposure**: security group `0.0.0.0/0` ingress on anything but 80/443 on an LB (port 22/3389/5432 open to world = finding), public S3/storage, databases with `publicly_accessible = true`.
- **Missing encryption flags**: unencrypted EBS/RDS/S3/disks — one attribute, big audit consequence.
- Hardcoded secrets in `.tf`/`.tfvars` (belongs in a secret manager, referenced at apply time); no `prevent_destroy` on stateful resources everyone assumes are permanent; unpinned providers/modules.
- Recommend automating this class: trivy/checkov/tfsec in CI catch ~80% of the above mechanically; the human review then covers what scanners can't — whether the *architecture* is sound.

## Reporting template

```
## Security review: <artifact>
Assumed context: <what this appears to be for; correct me if wrong>

### Critical — fix before shipping
1. <finding> — <how it gets exploited> 
   Fix: <corrected snippet>

### Should fix — hardening
...

### Consider — polish
...

## Corrected files
<when the artifacts are small (a Dockerfile, a manifest), end with the complete
corrected version the user can diff against — inline snippets fix findings,
but a full corrected file is what actually gets shipped>
```
