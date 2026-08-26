include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

terraform {
  source = "../../../../infrastructure-modules//terraform-cloudflare-zone"
}

dependency "dnshe_domain" {
  config_path = "../dnshe_domain"

  mock_outputs = {
    full_domain  = "mock.cc.cd"
    subdomain_id = 1
  }
  mock_outputs_allowed_terraform_commands = ["validate"]
}

inputs = {
  zone_name          = dependency.dnshe_domain.outputs.full_domain
  dnshe_subdomain_id = dependency.dnshe_domain.outputs.subdomain_id
  account_id         = local.account_vars.locals.cloudflare_account_id
}
