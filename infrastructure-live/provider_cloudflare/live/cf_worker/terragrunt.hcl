include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Secrets are read from the environment, never stored in HCL.
  # Export CF_WORKER_UUID before running plan/apply.
  worker_uuid = get_env("CF_WORKER_UUID", "")
}

terraform {
  source = "../../../../infrastructure-modules//terraform-cloudflare-worker"
}

dependency "cf_zone" {
  config_path = "../cf_zone"

  mock_outputs = {
    zone_id   = "mock-zone-id"
    zone_name = "mock.ccwu.cc"
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
}

# Pinned upstream worker script (cmliu/edgetunnel @ e2da274)
inputs = {
  script_url  = "https://raw.githubusercontent.com/cmliu/edgetunnel/e2da274be4148fb2f7d3ded10ce510157084a8df/_worker.js"
  worker_name = local.account_vars.locals.worker_name
  env_vars    = local.account_vars.locals.worker_env_vars
  secrets = {
    UUID = local.worker_uuid
  }
  account_id = local.account_vars.locals.cloudflare_account_id
  zone_id    = dependency.cf_zone.outputs.zone_id
  zone_name  = dependency.cf_zone.outputs.zone_name
}
