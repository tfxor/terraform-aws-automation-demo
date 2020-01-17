terraform {
  backend "local" {
    path = "/tmp/.terrahub/local_backend/demo-terraform-automation-aws/api_gateway_rest_api/terraform.tfstate"
  }
}
