# AGENTS.md

## What this repo is

Terragrunt + Terraform (OpenTofu) bootstrap for AWS: VPC, EKS, budgets, Kubernetes base config. Two top-level dirs:

- `infrastructure-live/` — Terragrunt env configs only (`root.hcl`, `provider.hcl`, `account.hcl`, per-component `terragrunt.hcl`). No `.tf` here.
- `infrastructure-modules/` — local Terraform modules consumed by live configs via relative sources like `source = "../../../../infrastructure-modules//terraform-kubernetes-config"`. Adding a module means editing both trees.

## Running commands

Never invoke `terraform`/`tofu`/`terragrunt` directly — everything runs through the pinned Docker image `devopsinfra/docker-terragrunt` via [Task](https://taskfile.dev):

```sh
task fmt        # check-only: terragrunt hcl format --all && tofu fmt -recursive -check
task validate   # terragrunt run-all init -reconfigure && terragrunt run-all validate
task plan       # terragrunt run-all plan
task apply      # terragrunt run-all apply --auto-approve  <-- real infra changes
task shell      # interactive bash in the container for ad-hoc commands
```

Gotchas:
- All tasks execute with workdir `infrastructure-live/provider_aws/dev` regardless of where you invoke them (see `BASE_DIR` in `Taskfile.yml`).
- AWS creds must be exported as env vars first (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`); Docker passes them through.
- To fix formatting (not just check it), run `terragrunt hcl format --all` / `tofu fmt -recursive` inside `task shell`.

## Config wiring

- `root.hcl` generates the AWS provider (region from `account.hcl`) with default tags from `provider.hcl`, and configures S3 remote state + DynamoDB lock in `eu-west-1`. Bucket/table names are placeholders ("change it" comments).
- Inter-module ordering uses Terragrunt `dependency` blocks (e.g. `kubernetes_config` reads `kubernetes_cluster` outputs for kube API host/CA), so `run-all` resolves order automatically — don't hand-sequence applies.

## Hygiene

- Ignore everything under `.terragrunt-cache/` and `.terraform/` — they're downloaded copies of upstream modules/state, gitignored, never edit them.
- CI (.github/workflows/ci.yml) only runs `task fmt` on PRs/pushes to `main` — formatting must be clean before pushing.
