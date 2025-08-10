resource "kubernetes_default_service_account" "default" {
  for_each = { for namespace in local.namespaces : namespace.name => namespace }
  metadata {
    namespace = each.key
  }

}

resource "kubernetes_namespace" "this" {
  for_each = { for namespace in local.namespaces : namespace.name => namespace }

  metadata {
    name        = each.key # The key of the map is the namespace name
    labels      = each.value.labels
    annotations = each.value.annotations
  }
}
