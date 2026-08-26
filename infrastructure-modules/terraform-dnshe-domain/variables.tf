variable "subdomain" {
  description = "Subdomain label to register on DNSHE (e.g. dataops-sre)"
  type        = string
}

variable "rootdomain" {
  description = "Root domain offered by DNSHE (e.g. cc.cd)"
  type        = string
}
