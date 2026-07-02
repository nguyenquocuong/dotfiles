# Infrastructure as Code (Terraform / Ansible)

## Terraform working discipline

- **`terraform plan` is read-only and cheap — run it liberally.** `apply` is the mutation; it needs user approval like any other. Always review the plan output *with* the user before an apply: call out destroys and replacements specifically (`-/+` means destroy-and-recreate, which for a database or EIP is an outage, not an update).
- **Why a resource is being replaced**: the plan marks the forcing attribute with `# forces replacement`. Often it's an immutable field that could instead be handled with `create_before_destroy`, a rename (→ use `moved` blocks / `terraform state mv`), or an unintended change.
- `terraform plan -target=` is a scalpel for emergencies, not a workflow — routine targeting means the config and reality have diverged and untargeted applies become scary. Flag it if the user's habit is target-everything.

## State problems (the perennial ones)

- **Drift** (someone changed reality outside Terraform): `terraform plan` shows it as unexpected changes. Decide direction explicitly: adopt reality into code (update the config to match, plan should go clean) or restore code's view (apply, reverting the manual change). Don't let drift sit — it makes every future plan noisy and erodes trust in the pipeline.
- **Import**: resource exists, state doesn't know it. Modern way: `import` blocks (1.5+) which are plan-reviewable, vs the older imperative `terraform import`. After import, iterate the config until plan is a no-op.
- **State surgery** (`state mv`, `state rm`): legitimate for refactors and splitting stacks, but it edits the source of truth with no undo except the backup. Back up first (`terraform state pull > backup.tfstate`), and prefer `moved`/`removed` blocks in code where the Terraform version allows — they're reviewable in a PR.
- **Locked state**: someone's apply crashed. Verify no apply is actually running before `force-unlock` — force-unlocking a live apply corrupts state.
- **Remote state backend** non-negotiables: versioned bucket + state locking (e.g. S3 + DynamoDB, or S3 lockfile in newer versions), encryption at rest, access restricted — state files contain secrets in plaintext (provider outputs, DB passwords). This is the most commonly overlooked IaC security issue.

## Structure and module judgment

- Split state by blast radius and change cadence: network/foundation (changes rarely, breaks everything) separate from per-service infra (changes often, breaks one thing). One giant state = every plan is slow and every apply risks everything; a hundred micro-states = dependency hell via remote state lookups. Most teams land on per-environment × per-layer.
- Modules are for repeated patterns with a stable interface, not for "wrapping one resource to enforce tagging" (use validation/policy for that) and not premature abstraction — a module with one caller is usually just indirection.
- Pin versions: providers with `~>` pessimistic constraints, modules to exact versions/tags. Unpinned providers are how "nothing changed but plan broke" happens.
- Environments: same code, different tfvars/backend per env — not copy-pasted directories that drift apart. Workspaces work but hide which env you're in; directory-per-env with shared modules is more explicit and harder to fat-finger prod.

## Ansible notes

- Idempotency is the contract: a playbook run twice should change nothing the second time. `changed_when`/`creates` on `command`/`shell` tasks, prefer real modules over shell.
- `--check` (+ `--diff`) is Ansible's plan: use before real runs on anything shared.
- Secrets: ansible-vault at minimum; better, look up from an external secret manager at runtime so secrets never land in the repo even encrypted.
- Inventory drift is Ansible's version of state drift — if hosts are managed by hand between runs, playbook runs become surprising. Same remedy: pick a source of truth.

## IaC in CI

Plan on PR (posted as a comment for review), apply on merge from a pipeline identity — not from laptops, so every change has an audit trail and a review. Store plan output as an artifact and apply *that* plan file (`terraform apply plan.out`) so what was reviewed is what runs. Add static checks (fmt, validate, tflint, and a security scanner like trivy/checkov) as cheap PR gates — details in `cicd.md` and `security-review.md`.
