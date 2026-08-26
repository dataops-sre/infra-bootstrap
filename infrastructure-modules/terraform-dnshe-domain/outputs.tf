output "full_domain" {
  description = "Fully qualified registered domain (subdomain.rootdomain)"
  value       = "${dnshe_subdomain.this.subdomain}.${dnshe_subdomain.this.rootdomain}"
}

output "subdomain_id" {
  description = "DNSHE numeric subdomain ID, used for NS delegation records"
  value       = dnshe_subdomain.this.id
}
