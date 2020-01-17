provider "aws" {
  version = "~> 2.44"
  region  = local.region
  allowed_account_ids = [
    local.account_id
  ]
}
