# Set common variables for the aws providers. This is automatically pulled in in the root terragrunt.hcl configuration to  configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  provider_wide_tags = {
    domain         = "data-platform"
    team           = "one-man-band"
    managed        = "terraform"
    free_tier      = true
    tagging_version = "1.0.0"
  }
}
