# Data platform terragrunt bootstrap

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
4) run `terragrunt apply-all` in `/mnt/infrastructure-live` you will have a Kubernetes cluster with name `test-eks-irsa` ready in less than 10 minutes and it will deploy additional tools such as `cluster-autoscaler`, `spot-instance-handler`, `ingress controller` and `airflow`

```bash
$terragrunt-dataplaform-bootstrap (git)-[main] % task run-image
bash-5.0# pwd
/mnt/infrastructure-live
bash-5.0# terragrunt apply-all
...
aws_iam_policy.cluster_autoscaler: Creation complete after 1s 
module.iam_assumable_role_admin.aws_iam_role_policy_attachment.custom[0]: Creating...
module.iam_assumable_role_admin.aws_iam_role_policy_attachment.custom[0]: Creation complete after 1s [id=cluster-autoscaler-20201129231704909500000019]

Apply complete! Resources: 57 added, 0 changed, 0 destroyed.
Releasing state lock. This may take a few moments...
...
helm_release.aiflow: Still creating... [1m20s elapsed]
helm_release.aiflow: Still creating... [1m30s elapsed]
helm_release.aiflow: Creation complete after 1m40s [id=airflow]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
...
...
terragrunt-dataplaform-bootstrap (git)-[main] % aws eks --region eu-west-2 update-kubeconfig --name test-eks-irsa --role-arn "arn:aws:iam::xxxxxx:role/xxxxxx"
$terragrunt-dataplaform-bootstrap (git)-[main] % kubectl get pod -n kube-system
NAME                                                        READY   STATUS    RESTARTS   AGE
aws-node-rtts8                                              1/1     Running   0          2m46s
aws-node-z9sg4                                              1/1     Running   0          2m42s
cluster-autoscaler-aws-cluster-autoscaler-5bd88ccc8-x6nkn   1/1     Running   0          88s
coredns-6ddcfb5bcf-6lm5q                                    1/1     Running   0          6m42s
coredns-6ddcfb5bcf-hff8c                                    1/1     Running   0          6m42s
kube-proxy-9vh9l                                            1/1     Running   0          2m46s
kube-proxy-cwtfr                                            1/1     Running   0          2m42s
spot-handler-k8s-spot-termination-handler-jbwfl             1/1     Running   0          93s
spot-handler-k8s-spot-termination-handler-lhrzf             1/1     Running   0          93s
traefik-ingress-controller-d999b849b-z85rr                  1/1     Running   0          84s
$terragrunt-dataplaform-bootstrap (git)-[main] % kubectl get pod -n default
NAME                       READY   STATUS    RESTARTS   AGE
airflow-7fbb8f4b58-2djlc   1/1     Running   0          103s
airflow-postgresql-0       1/1     Running   0          103s
```

Those steps can be further automated in CI/CD pipelines.

## Access to cluster
``` bash
aws eks --region eu-west-2 update-kubeconfig --name test-eks-irsa --role-arn "arn:aws:iam::xxxxxx:role/xxxxxx"  
```
will configure kubernetes access, then you can make kubernetes operations with `kubectl` command

To access to the airflow instance, you can use kubernetes port forwarding
