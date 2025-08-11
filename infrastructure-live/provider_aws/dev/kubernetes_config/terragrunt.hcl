include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../infrastructure-modules//terraform-kubernetes-config"
}

dependency "kubernetes_cluster" {
  config_path = "../kubernetes_cluster"
}


inputs = {
  host                   = dependency.kubernetes_cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(dependency.kubernetes_cluster.outputs.cluster_certificate_authority_data)

  cluster_name = dependency.kubernetes_cluster.outputs.cluster_name

}
