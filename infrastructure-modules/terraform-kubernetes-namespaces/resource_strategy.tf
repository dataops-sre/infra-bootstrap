resource "kubernetes_limit_range" "this" {
  for_each = { for i in local.namespaces : i.name => i }
  metadata {
    name      = "${each.value.name}-limit-range"
    namespace = each.value.name
  }

  spec {
    dynamic "limit" {
      for_each = var.limits
      content {
        type                    = lookup(limit.value, "type", null)
        default_request         = lookup(limit.value, "default_request", null)
        max                     = lookup(limit.value, "max", null)
        min                     = lookup(limit.value, "min", null)
        max_limit_request_ratio = lookup(limit.value, "max_limit_request_ratio", null)
      }
    }
  }

  depends_on = [kubernetes_namespace.this]
}

resource "kubernetes_resource_quota" "this" {
  for_each = { for i in local.namespaces : i.name => i if var.namespaced_resources_quota != null }
  metadata {
    name      = "${each.value.name}-resource-quota"
    namespace = each.value.name
  }
  spec {
    hard = var.namespaced_resources_quota
  }

  depends_on = [kubernetes_namespace.this]
}
