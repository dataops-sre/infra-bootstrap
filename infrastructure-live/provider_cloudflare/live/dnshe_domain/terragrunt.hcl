include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
}

terraform {
  source = "../../../../infrastructure-modules//terraform-dnshe-domain"
}

inputs = {
  subdomain  = local.account_vars.locals.subdomain_label
  rootdomain = local.account_vars.locals.root_domain
}
