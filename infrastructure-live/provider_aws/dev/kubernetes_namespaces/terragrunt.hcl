include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../infrastructure-modules//terraform-kubernetes-namespaces"
}

dependency "kubernetes_cluster" {
  config_path = "../kubernetes_cluster"
}

inputs = {
  host                   = dependency.kubernetes_cluster.outputs.cluster_endpoint
  cluster_ca_certificate = base64decode(dependency.kubernetes_cluster.outputs.cluster_certificate_authority_data)

  cluster_name           = dependency.kubernetes_cluster.outputs.cluster_name

  groups = [
    {
      name : "data-engineering"
      namespaces = [
        { name : "argo" },
        { name : "argo-events" },
        { name : "data-ingestion" },
        { name : "airflow" },
      ]
    },
    {
      name : "sre-engineering"
      namespaces = [
        { name : "cert-manager" },
        { name : "gemini" },
        { name : "gitlab-runner" },
        { name : "kyverno" },
        { name : "kubernetes-replicator" },
        { name : "monitoring" },
        { name : "traefik" },
        { name : "traefik-external" },
        { name : "traefik-internal" },
        { name : "vpa" },
      ]
    }
  ]
}
