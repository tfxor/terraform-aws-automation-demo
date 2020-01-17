data "terraform_remote_state" "iam" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/iam_role/terraform.tfstate"
  }
}

data "terraform_remote_state" "sg" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/security_group/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/subnet_private/terraform.tfstate"
  }
}
