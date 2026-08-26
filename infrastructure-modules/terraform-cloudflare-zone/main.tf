resource "cloudflare_zone" "this" {
  account = {
    id = var.account_id
  }
  name = var.zone_name
  type = "full"
}

resource "dnshe_dns_record" "ns_delegation" {
  # Cloudflare always assigns exactly 2 nameservers per zone; they are only
  # known after apply, which breaks count evaluation during plan.
  count = 2

  subdomain_id = var.dnshe_subdomain_id
  type         = "NS"
  # name omitted: empty = zone apex; the API echoes back a different form,
  # and since the attribute is Computed, tofu must be free to accept it.
  content = cloudflare_zone.this.name_servers[count.index]
}
