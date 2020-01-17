resource "aws_subnet" "subnet_private" {
  vpc_id                          = data.terraform_remote_state.vpc.outputs.thub_id
  cidr_block                      = cidrsubnet("11.0.1.0/24", 4, count.index)
  count                           = length(data.aws_availability_zones.az.names)
  assign_ipv6_address_on_creation = false
  availability_zone               = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch         = false
  tags = {
    "Name"        = "terraform-aws-automation-demo",
    "Description" = "Managed by TerraHub",
    "ThubCode"    = "7356626c",
    "ThubEnv"     = "default"
  }
}
