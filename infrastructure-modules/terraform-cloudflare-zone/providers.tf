terraform {
  required_version = ">= 1.6.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    dnshe = {
      source  = "registry.terraform.io/serialt/dnshe"
      version = "0.1.3"
    }
  }
}

provider "cloudflare" {}

provider "dnshe" {}
