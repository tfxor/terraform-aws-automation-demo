resource "aws_security_group" "security_group" {
  description = "default VPC security group"
  name        = "terraform-aws-automation-demo"
  vpc_id      = lookup(data.terraform_remote_state.vpc.outputs, "thub_id", "Is not set!")

  egress {
    to_port     = 0
    description = "default VPC security group"
    from_port   = 0
    protocol    = -1
    self        = true
  }

  ingress {
    description = "default VPC security group"
    from_port   = 0
    protocol    = -1
    self        = true
    to_port     = 0
  }

  tags = {
    Description = "Managed by TerraHub",
    Name        = "terraform-aws-automation-demo",
    ThubCode    = "7356626c",
    ThubEnv     = "default"
  }
}
