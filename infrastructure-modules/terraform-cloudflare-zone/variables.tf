variable "zone_name" {
  description = "Full domain to host as a Cloudflare zone (e.g. mynode.us.ci)"
  type        = string
}

variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "dnshe_subdomain_id" {
  description = "DNSHE numeric subdomain ID used to create the NS delegation records"
  type        = number
}
