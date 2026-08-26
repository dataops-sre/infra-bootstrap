locals {
  environment = "live"

  cloudflare_account_id = "f953a67db1e4af132032cc58e29a27c1"

  subdomain_label = "dataops-sre"
  root_domain     = "ccwu.cc"

  worker_name     = "proxy-worker"
  worker_env_vars = {
    PROXYIP = "" # e.g. "proxyip.fxxk.dev" or a preferred proxy IP
  }
}
