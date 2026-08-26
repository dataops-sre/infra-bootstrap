output "worker_name" {
  value = cloudflare_workers_script.this.script_name
}

output "custom_domain" {
  value = cloudflare_workers_custom_domain.this.hostname
}

output "kv_namespace_id" {
  value = cloudflare_workers_kv_namespace.this.id
}
