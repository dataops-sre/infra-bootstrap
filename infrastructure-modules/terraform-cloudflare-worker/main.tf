data "http" "remote" {
  url = var.script_url
}

resource "cloudflare_workers_kv_namespace" "this" {
  account_id = var.account_id
  title      = var.kv_namespace_title
}

resource "cloudflare_workers_script" "this" {
  account_id         = var.account_id
  script_name        = var.worker_name
  content            = data.http.remote.response_body
  main_module        = "worker.js"
  compatibility_date = var.compatibility_date

  bindings = concat(
    [{
      name         = "KV"
      type         = "kv_namespace"
      namespace_id = cloudflare_workers_kv_namespace.this.id
    }],
    [for k, v in var.env_vars : {
      name = k
      type = "plain_text"
      text = v
    }],
    [for k, v in var.secrets : {
      name = k
      type = "secret_text"
      text = v
    }]
  )
}

resource "cloudflare_workers_custom_domain" "this" {
  account_id = var.account_id
  zone_id    = var.zone_id
  zone_name  = var.zone_name
  hostname   = coalesce(var.hostname, var.zone_name)
  service    = cloudflare_workers_script.this.script_name
}
