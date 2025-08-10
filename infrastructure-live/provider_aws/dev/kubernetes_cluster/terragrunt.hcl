terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=21.0.8"
}

include {
  path = find_in_parent_folders("root.hcl")
}

# get the outputs from the sibling VPC module
dependency "vpc" {
  config_path = "../vpc"
}

locals {
  cluster_name = "data-platform-dev-cluster"
  # k8s control plane version
  kubernetes_version = "1.33"
  # Use yaml file to configure node_groups for clarity
  node_groups_yaml = file("${get_terragrunt_dir()}/node_groups.yaml")
  eks_managed_node_groups = yamldecode(local.node_groups_yaml).node_groups
}

inputs = {
  # basics
  name    = local.cluster_name
  kubernetes_version = local.kubernetes_version

  # use VPC created in ../vpc module — common outputs are vpc_id and private_subnets
  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  # EKS Addons
   addons = {
     coredns = {}
     eks-pod-identity-agent = {
       before_compute = true
     }
     kube-proxy = {}
     vpc-cni = {
       before_compute = true
     }
   }

  # network endpoint exposure
  enable_cluster_creator_admin_permissions = true
  endpoint_public_access                   = true

  # best-practice flags
  enable_irsa               = true   # enables creation of OIDC provider for IRSA


  # small managed node group example (change instance types / capacity_type as needed)
  eks_managed_node_groups = local.eks_managed_node_groups

}
