variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "worker_name" {
  description = "Worker script name (used in URLs and routes)"
  type        = string
  default     = "proxy-worker"
}

variable "script_url" {
  description = "URL to fetch the worker JS from (e.g. a pinned raw GitHub URL)"
  type        = string
}

variable "compatibility_date" {
  description = "Workers compatibility date"
  type        = string
  default     = "2024-09-23"
}

variable "kv_namespace_title" {
  description = "Title of the KV namespace bound to the worker"
  type        = string
  default     = "proxy-kv"
}

variable "zone_id" {
  description = "Cloudflare zone ID hosting the custom domain"
  type        = string
}

variable "zone_name" {
  description = "Cloudflare zone name hosting the custom domain"
  type        = string
}

variable "hostname" {
  description = "Custom domain hostname for the worker; defaults to the zone apex"
  type        = string
  default     = null
}

variable "env_vars" {
  description = "Plain-text environment variable bindings for the worker (non-secret only)"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret bindings for the worker (secret_text type); values come from env vars, never committed"
  type        = map(string)
  default     = {}
}
