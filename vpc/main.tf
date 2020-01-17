resource "aws_vpc" "vpc" {
  cidr_block                       = "11.0.0.0/23"
  assign_generated_ipv6_cidr_block = true
  enable_classiclink               = false
  enable_classiclink_dns_support   = false
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags                             = map("Description", "Managed by TerraHub", "Name", "terraform-aws-automation-demo", "ThubCode", "7356626c", "ThubEnv", "default")
}
