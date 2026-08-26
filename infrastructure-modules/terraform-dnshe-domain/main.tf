resource "dnshe_subdomain" "this" {
  subdomain  = var.subdomain
  rootdomain = var.rootdomain
}
