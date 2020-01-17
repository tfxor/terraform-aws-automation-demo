data "terraform_remote_state" "vpc" {
  backend   = "local"
  workspace = "${terraform.workspace}"
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/vpc/terraform.tfstate"
  }
}
