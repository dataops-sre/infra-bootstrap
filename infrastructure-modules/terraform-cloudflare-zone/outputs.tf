output "zone_id" {
  value = cloudflare_zone.this.id
}

output "zone_name" {
  value = cloudflare_zone.this.name
}

output "name_servers" {
  value = cloudflare_zone.this.name_servers
}
