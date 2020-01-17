terraform {
  backend "local" {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/iam_role/terraform.tfstate"
  }
}
