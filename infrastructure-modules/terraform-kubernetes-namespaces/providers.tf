terraform {

  required_providers {
    kubernetes = { # https://search.opentofu.org/provider/opentofu/kubernetes/v2.21.1
      source  = "opentofu/kubernetes"
      version = "2.21.1"
    }
  }
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = var.host
  cluster_ca_certificate = var.cluster_ca_certificate
  token                  = data.aws_eks_cluster_auth.this.token
}
