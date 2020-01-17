data "terraform_remote_state" "vpc" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/terraform-aws-automation-demo/vpc/terraform.tfstate"
  }
}
