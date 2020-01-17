data "terraform_remote_state" "iam" {
  workspace = terraform.workspace
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/iam_role/terraform.tfstate"
  }
  backend = "local"
}

data "terraform_remote_state" "sg" {
  workspace = terraform.workspace
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/security_group/terraform.tfstate"
  }
  backend = "local"
}

data "terraform_remote_state" "subnet" {
  workspace = terraform.workspace
  config = {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/subnet_private/terraform.tfstate"
  }
  backend = "local"
}
