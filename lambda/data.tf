data "terraform_remote_state" "iam" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/terraform-aws-automation-demo/iam_role/terraform.tfstate"
  }
}

data "terraform_remote_state" "sg" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/terraform-aws-automation-demo/security_group/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  workspace = terraform.workspace
  backend   = "local"
  config = {
    path = "/tmp/.terrahub/local_backend/terraform-aws-automation-demo/subnet_private/terraform.tfstate"
  }
}
