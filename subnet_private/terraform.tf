terraform {
  backend "local" {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/subnet_private/terraform.tfstate"
  }
}
