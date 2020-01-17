resource "aws_subnet" "subnet_private" {
  tags                            = map("Description", "Managed by TerraHub", "Name", "demo-terraform-automation-aws", "ThubCode", "7356626c", "ThubEnv", "default")
  vpc_id                          = data.terraform_remote_state.vpc.outputs.thub_id
  cidr_block                      = cidrsubnet("11.0.1.0/24", 4, count.index)
  count                           = length(data.aws_availability_zones.az.names)
  assign_ipv6_address_on_creation = false
  availability_zone               = element(data.aws_availability_zones.az.names, count.index)
  map_public_ip_on_launch         = false
}
