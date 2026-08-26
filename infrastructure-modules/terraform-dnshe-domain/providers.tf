terraform {
  required_version = ">= 1.6.0"

  required_providers {
    dnshe = {
      source  = "registry.terraform.io/serialt/dnshe"
      version = "0.1.3"
    }
  }
}

provider "dnshe" {}
