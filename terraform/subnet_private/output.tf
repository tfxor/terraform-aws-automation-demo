output "id" {
  value = aws_subnet.subnet_private.*.id
}
output "thub_id" {
  value = aws_subnet.subnet_private.*.id
}
output "availability_zone" {
  value = aws_subnet.subnet_private.*.availability_zone
}
output "cidr_block" {
  value = aws_subnet.subnet_private.*.cidr_block
}
output "vpc_id" {
  value = aws_subnet.subnet_private.*.vpc_id
}
