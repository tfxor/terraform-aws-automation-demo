output "main_route_table_id" {
  value = aws_vpc.vpc.main_route_table_id
}

output "ipv6_association_id" {
  value = aws_vpc.vpc.ipv6_association_id
}

output "ipv6_cidr_block" {
  value = aws_vpc.vpc.ipv6_cidr_block
}

output "id" {
  value = aws_vpc.vpc.id
}

output "default_security_group_id" {
  value = aws_vpc.vpc.default_security_group_id
}

output "arn" {
  value = aws_vpc.vpc.arn
}

output "dhcp_options_id" {
  value = aws_vpc.vpc.dhcp_options_id
}

output "enable_dns_hostnames" {
  value = aws_vpc.vpc.enable_dns_hostnames
}

output "enable_classiclink_dns_support" {
  value = aws_vpc.vpc.enable_classiclink_dns_support
}

output "thub_id" {
  value = aws_vpc.vpc.id
}

output "default_network_acl_id" {
  value = aws_vpc.vpc.default_network_acl_id
}

output "default_route_table_id" {
  value = aws_vpc.vpc.default_route_table_id
}

output "owner_id" {
  value = aws_vpc.vpc.owner_id
}

output "enable_classiclink" {
  value = aws_vpc.vpc.enable_classiclink
}
