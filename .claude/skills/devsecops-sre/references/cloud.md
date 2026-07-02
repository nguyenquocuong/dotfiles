# Cloud Operations (AWS / GCP / Azure)

Cross-cloud principles first, provider-specific notes after. When the user's provider is known, answer in that provider's terms — don't give three-way comparisons unless they're actually choosing.

## IAM — where most cloud security lives

- **Identities over keys.** Long-lived access keys (AWS keys in `~/.aws/credentials`, GCP service-account JSON files) are the #1 leaked credential. Prefer: roles assumed by workloads (EC2 instance profiles, EKS IRSA / Pod Identity, GKE Workload Identity, Azure Managed Identities), OIDC federation for CI, and SSO for humans. A downloaded service-account key should be treated as a smell needing justification.
- **Least privilege is iterative, not aspirational.** Start narrower than comfortable and widen on real AccessDenied errors — the reverse (start with `*`, tighten later) never actually happens. AWS: IAM Access Analyzer and CloudTrail-based policy generation make "what does this thing actually use" answerable.
- Red flags to call out on sight: `"Action": "*"` / `"Resource": "*"` in anything but a break-glass admin role, IAM users with console passwords *and* access keys, cross-account trust without `sts:ExternalId` or conditions, public S3 buckets/storage without an explicit "this is a website" reason.
- Permission boundaries / SCPs (AWS), org policy (GCP), Azure Policy: guardrails that hold even when someone fat-fingers an IAM policy. Worth it once more than one team shares an org.

## Networking

- Default posture: private subnets for workloads, public only for load balancers/NAT; security groups that reference other security groups (not CIDR ranges) for service-to-service; deny-by-default and open specific flows.
- Egress control is usually forgotten: unrestricted egress means any compromised pod can exfiltrate anywhere. Even coarse controls (NAT + logging, or an egress allowlist for sensitive workloads) raise the bar a lot.
- VPC endpoints / Private Google Access / Private Link keep cloud-API traffic off the public internet and often cut NAT costs too.
- DNS and connectivity debugging order: instance/pod → subnet route table → NACL/firewall → security group → the target's security group. Most "can't connect" issues are a security group on the *destination*.

## Cost sanity

- The big three cost surprises: NAT gateway data processing (per-GB, silently expensive for chatty workloads), cross-AZ/cross-region traffic, and forgotten resources (unattached EBS/IPs, idle load balancers, oversized dev instances running 24/7).
- Order of operations for cost work: visibility first (cost allocation tags, per-team/per-service breakdown), then rightsizing (utilization data, not guesses), then commitment discounts (Savings Plans / CUDs / Reservations) — committing before rightsizing locks in the waste.
- Spot/preemptible for anything interruption-tolerant (CI runners, batch, stateless replicas behind sufficient capacity) is routinely a 60–80% cut.

## Service selection judgment

When advising "which service should I use", the decisive inputs are: team's existing operational skill, scale actually needed (not aspirational), and how much undifferentiated ops burden they can carry. Recurring examples:

- **Kubernetes (EKS/GKE/AKS) vs simpler compute (ECS/Fargate, Cloud Run, App Service)**: K8s buys flexibility and ecosystem at a permanent operational tax (upgrades, add-ons, security posture). A small team with a handful of stateless services is usually better on the simpler tier; the honest question is "who maintains the cluster at 2am".
- **Managed database vs self-hosted**: managed (RDS, Cloud SQL, etc.) wins by default — backups, patching, failover are exactly the undifferentiated work to shed. Self-host only for a hard requirement the managed tier can't meet (extensions, versions, extreme cost at scale).
- **Serverless vs always-on**: spiky/low traffic → serverless wins on cost and ops; steady high traffic → always-on wins on cost and cold-start latency. Watch concurrency limits and per-invocation pricing at the crossover.
- Multi-cloud as a *requirement* is rare (regulatory, acquisition); as a *strategy* it usually means lowest-common-denominator tooling and doubled expertise cost. Portability via K8s/Terraform is a reasonable hedge; active multi-cloud is a cost most teams shouldn't pay.

## Observability baseline

Whatever the provider: structured logs centralized with retention you can afford, the four golden signals (latency, traffic, errors, saturation) per service, alerts on symptoms (user-facing error rate/latency SLOs) not causes (CPU high), and audit logging (CloudTrail / Cloud Audit Logs / Activity Log) enabled org-wide, immutable, in a separate account/project — that separation is what makes it useful after a compromise.

## Provider-specific gotchas worth knowing

- **AWS**: default VPC and default security groups are permissive — build your own; S3 Block Public Access at the account level; GuardDuty is cheap signal, turn it on; instance metadata must be IMDSv2-only (IMDSv1 is an SSRF-to-credentials bridge).
- **GCP**: default service account has Editor on the whole project — replace it on every workload; org-level policies (disable SA key creation, domain-restricted sharing) prevent whole bug classes; firewall rules are VPC-global, not per-subnet.
- **Azure**: RBAC assignments at management-group/subscription scope inherit broadly — audit who has Owner where; NSGs vs Azure Firewall layering confuses people (NSG = security group equivalent); enable Defender for Cloud's free tier posture checks at minimum.
