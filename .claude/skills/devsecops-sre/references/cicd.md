# CI/CD Pipelines

Pipeline design, secrets, supply-chain security, deployment strategies. Examples lean GitHub Actions / GitLab CI since those dominate, but the principles transfer.

## Pipeline design principles

- **Fail fast, cheap checks first**: lint/format/unit before build, build before integration, integration before deploy. A 40-minute pipeline that fails on a lint error at minute 38 trains people to bypass CI.
- **Reproducibility**: pin action/image versions (see supply chain below), lock dependencies, build once and promote the *same artifact* through stages — rebuilding per environment means you test one artifact and ship another.
- **Every deploy has an audit trail**: triggered by whom, from what commit, with what config. Deploys from laptops break this; if the team does that routinely, it's a systemic gap worth naming.
- Keep pipeline logic in the repo and thin: complex bash embedded in YAML is untestable — move it to scripts that can run locally.

## Secrets in CI

Ranked from what to recommend down to what to migrate away from:

1. **OIDC federation to the cloud provider** (GitHub/GitLab → AWS/GCP/Azure): no stored long-lived credentials at all; the CI run exchanges its identity token for short-lived cloud creds, scoped per repo/branch. This is the modern answer to "how do I give CI access to AWS" and should be the default recommendation.
2. **Secret manager references** (Vault, AWS Secrets Manager, etc.) fetched at runtime by a narrowly-scoped identity.
3. **Platform secret stores** (GitHub Actions secrets, GitLab CI variables): fine for small setups; weaknesses are no rotation story, coarse scoping, and anyone-with-write-access-can-exfiltrate via a modified workflow.
4. **Secrets in the repo** — never, including "just for now", including encrypted-except-the-key-is-also-here. If found in history, rotate the secret; scrubbing history is secondary (the secret must be assumed leaked).

Watch for secrets leaking into logs (`set -x` in scripts, verbose curl, error messages that echo env). Masking helps but isn't a guarantee.

## Supply-chain security

The pipeline *is* an attack surface: it has prod credentials and runs code from PRs and third parties.

- **Pin third-party actions/images to a SHA**, not a mutable tag. `uses: some-action@v3` trusts whoever controls that tag forever; a compromised action with your secrets in env is game over. Dependabot can keep pinned SHAs fresh.
- **`pull_request_target` and untrusted code** (GitHub): workflows triggered by fork PRs must never run fork-controlled code with secrets available. This is the classic CI RCE; scrutinize any `pull_request_target` workflow that checks out the PR head.
- **Least-privilege workflow tokens**: set `permissions:` explicitly per workflow (default token is too broad); scope deploy credentials per environment with required reviewers on the prod environment.
- **Runner posture**: self-hosted runners on public repos are dangerous (anyone's PR runs code on your infra). Ephemeral runners > long-lived ones.
- Base image hygiene: pinned digests, minimal/distroless where feasible, scheduled rebuilds so patches actually land (a pinned image never gets patched by itself). Image scanning (trivy/grype) as a gate for new criticals.

## Deployment strategies

Match the strategy to what a bad deploy costs, not to what's fashionable:

- **Rolling** (default): simple, near-zero extra capacity; bad version reaches users gradually but *does* reach them. Fine when rollback is fast and errors are tolerable-for-minutes.
- **Blue/green**: full parallel environment, instant cutover and instant rollback; costs 2× capacity during deploys and doesn't help with gradual poison (config that fails only under sustained load).
- **Canary**: small % of real traffic first, promoted on metrics; the best safety-per-dollar *if* you have the metrics and either patience or automation (Argo Rollouts, Flagger) to evaluate it. A canary nobody watches is just a slow rolling deploy.
- Feature flags decouple deploy from release and give per-feature rollback — often more valuable than a fancier deploy strategy, and they compose with all of the above.
- Whatever the strategy: automated rollback criteria beat "someone watches the dashboard", and database migrations need to be backward-compatible with the previous app version (expand → migrate → contract), or every rollback story is a lie.

## GitOps

Argo CD / Flux: git as the source of truth, a controller converges the cluster to it. Wins: drift detection/correction, audit-by-git-history, no cluster credentials in CI (the controller pulls). Costs: another moving part, and secrets need a separate story (sealed-secrets, external-secrets, SOPS). Worth recommending once more than a couple of services or people deploy to the same cluster.
