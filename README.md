# Infra as code bootstrap

This repository provides a ready-to-use **Infrastructure as Code (IaC) bootstrap template** using [Terragrunt](https://terragrunt.gruntwork.io/) and [Terraform](https://www.terraform.io/) to deploy AWS infrastructure (VPC, EKS, budgets, Kubernetes base config, namespaces) in a modular and reusable way.

It supports spot instances, autoscales based on cluster load, **configures AWS budget alerting**, and is designed to make use of AWS Free Tier resources as much as possible.

## Components
Infrastructure components:

* [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)
* [Kubernetes Provider for Terraform](https://github.com/hashicorp/terraform-provider-kubernetes)
* [Helm Provider for Terraform](https://github.com/hashicorp/terraform-provider-helm/)
* [AWS Budgets](https://docs.aws.amazon.com/cost-management/latest/userguide/budgets-managing-costs.html) for cost monitoring and alerting

Software components:

* Ingress controller: [traefik](https://github.com/traefik/traefik)

## How to use

The project use the standard terragrunt project structure, detailed explication [here](https://blog.gruntwork.io/terragrunt-how-to-keep-your-terraform-code-dry-and-maintainable-f61ae06959d8).

## Prerequisites
* AWS CLI configured with necessary permissions
* **Docker & Docker Compose `3.x`**: For creating consistent, reproducible environments for the application, tests, and development (Jupyter).
* **Taskfile**: A simple, `make`-like build tool for automating common commands (e.g., running the job, tests).


## Typical local workflow
1. Assume your AWS admin role, make sure you have AWS environments variables with shell
  ```sh
  ❯ env | grep AWS
  AWS_ACCESS_KEY_ID=xxxxxx
  AWS_SECRET_ACCESS_KEY=xxxxxx
  AWS_SESSION_TOKEN=xxxxxx
  ```

2. Run format check: `task fmt`

3. Validate configuration `task validate`

4. Plan infrastructure changes: `task plan`

5. Apply infrastructure changes: `task apply`

6. Configure kubectl:
  ``` bash
  aws eks --region eu-west-1 update-kubeconfig --name <cluster-name>
  ```
7. Verify cluster and pods:
  ``` bash
  kubectl get pods -n kube-system
  kubectl get pods -n default
  ```

## CI/CD Integration

The file format validation is run on pull requests to ensure code consistency and prevent formatting drift.

## Cost Management
This IaC setup also provisions AWS Budgets to send alerts when costs approach or exceed defined thresholds.
Where possible, it uses AWS Free Tier–eligible services and configurations to minimize costs during development and testing.
