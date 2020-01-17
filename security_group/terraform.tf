terraform {
  backend "local" {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/security_group/terraform.tfstate"
  }
}
