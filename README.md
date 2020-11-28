# DATA platform terragrunt bootstrap

This repository bootstrap a scalable Managed Kubernetes cluster(EKS) on AWS with terragrunt

It supports spot instances and autoscales regarding cluster loads 

## Components

Infrastructure components:

* [terraform-aws-eks](https://github.com/terraform-aws-modules/terraform-aws-eks)
* [Kubernetes Provider for Terraform](https://github.com/hashicorp/terraform-provider-kubernetes)
* [Helm Provider for Terraform](https://github.com/hashicorp/terraform-provider-helm/)
* [cluster-autoscaler](https://github.com/kubernetes/autoscaler)
* [k8s-spot-termination-handler](https://github.com/pusher/k8s-spot-termination-handler)

Software components:

* Ingress controller: [traefik](https://github.com/traefik/traefik)
* Airflow scheduler: [airflow](https://github.com/apache/airflow)

## How to use

The project use the standard terragrunt project structure, detailed explication [here](https://blog.gruntwork.io/terragrunt-how-to-keep-your-terraform-code-dry-and-maintainable-f61ae06959d8).

Manual steps: 

1) Assume an aws admin role
2) run `task run-image` mount code base into a terragrunt image
3) modify `iam_role` configuration in `/infrastructure-live/dev/terragrunt.hcl` to your admin role
4) run `terragrunt apply` in `/mnt/infrastructure-live/dev/aws/eks` you will have your Kubernetes cluster ready in less than 10 minutes
5) modify `eks_cluster_endpoint` configuration in `/infrastructure-live/dev/terragrunt.hcl` to the newly bootstrapped cluster endpoint
6) run `terragrunt apply` in `/mnt/infrastructure-live/dev/kubernetes/mgmt` will deploy additional tools such as `cluster-autoscaler`, `spot-instance-handler`, `ingress controller` and `airflow`

Those steps can be further automated in CI/CD pipelines.

## Access to cluster
``` bash
aws eks --region eu-west-2 update-kubeconfig --name test-eks-irsa --role-arn "arn:aws:iam::xxxxxx:role/xxxxxx"  
```
will configure kubernetes access, then you can make kubernetes operations with `kubectl` command

To access to the airflow instance, you can use kubernetes port forwarding
