terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=6.0.1"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name = "data-platform-dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = true  # it is not with free tier
  single_nat_gateway     = true  # saves cost, 1 NAT GW for all AZs
  enable_dns_hostnames   = true
  enable_dns_support     = true
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

}
