#!/usr/bin/env bash

aws --version > /dev/null 2>&1 || { echo >&2 "aws is missing. aborting..."; exit 1; }
npm --version > /dev/null 2>&1 || { echo >&2 "npm is missing. aborting..."; exit 1; }
export NODE_PATH="$(npm root -g)"

if [ -z "${BRANCH_FROM}" ]; then BRANCH_FROM = "dev"; fi
if [ -z "${BRANCH_TO}" ]; then BRANCH_TO = "dev"; fi
if [ "${THUB_STATE}" == "approved" ]; then THUB_APPLY="-a"; fi
if [ "${BRANCH_TO}" != "${BRANCH_FROM}" ]; then GIT_DIFF="-g ${BRANCH_TO}...${BRANCH_FROM}"; fi

git --version > /dev/null 2>&1 || { echo >&2 "git is missing. aborting..."; exit 1; }
git checkout $BRANCH_TO
git checkout $BRANCH_FROM

terrahub --version > /dev/null 2>&1 || { echo >&2 "terrahub is missing. aborting..."; exit 1; }
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output=text --query='Account')"
terrahub configure -c template.locals.account_id="${AWS_ACCOUNT_ID}"

terrahub configure -c template.terraform.backend.s3.bucket="data-lake-terrahub-us-east-1"
terrahub configure -c template.terraform.backend.s3.region="us-east-1"
terrahub configure -c template.terraform.backend.s3.workspace_key_prefix="terraform_workspaces"
terrahub configure -c component.template.terraform.backend -D -y -i "api_gateway_deployment"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/api_gateway_deployment/terraform.tfstate" -i "api_gateway_deployment"
terrahub configure -c component.template.tfvars -D -y -i "api_gateway_deployment"
terrahub configure -c terraform.varFile[]="s3://data-lake-terrahub-us-east-1/tfvars/terrahubcorp/demo-terraform-automation-aws/api_gateway_deployment/default.tfvars" -i "api_gateway_deployment"
terrahub configure -c component.template.terraform.backend -D -y -i "api_gateway_rest_api"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/api_gateway_rest_api/terraform.tfstate" -i "api_gateway_rest_api"
terrahub configure -c component.template.terraform.backend -D -y -i "iam_role"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/iam_role/terraform.tfstate" -i "iam_role"
terrahub configure -c component.template.terraform.backend -D -y -i "lambda"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/lambda/terraform.tfstate" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.iam -D -y -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.iam.backend="s3" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.iam.config.bucket="data-lake-terrahub-us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.iam.config.region="us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.iam.config.key="terraform/terrahubcorp/demo-terraform-automation-aws/iam_role/terraform.tfstate" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.subnet -D -y -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.subnet.backend="s3" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.subnet.config.bucket="data-lake-terrahub-us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.subnet.config.region="us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.subnet.config.key="terraform/terrahubcorp/demo-terraform-automation-aws/subnet_private/terraform.tfstate" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.sg -D -y -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.sg.backend="s3" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.sg.config.bucket="data-lake-terrahub-us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.sg.config.region="us-east-1" -i "lambda"
terrahub configure -c component.template.data.terraform_remote_state.sg.config.key="terraform/terrahubcorp/demo-terraform-automation-aws/security_group/terraform.tfstate" -i "lambda"
terrahub configure -c component.template.terraform.backend -D -y -i "security_group"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/security_group/terraform.tfstate" -i "security_group"
terrahub configure -c component.template.data.terraform_remote_state.vpc -D -y -i "security_group"
terrahub configure -c component.template.data.terraform_remote_state.vpc.backend="s3" -i "security_group"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.bucket="data-lake-terrahub-us-east-1" -i "security_group"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.region="us-east-1" -i "security_group"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.key="terraform/terrahubcorp/demo-terraform-automation-aws/vpc/terraform.tfstate" -i "security_group"
terrahub configure -c component.template.terraform.backend -D -y -i "subnet_private"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/subnet_private/terraform.tfstate" -i "subnet_private"
terrahub configure -c component.template.data.terraform_remote_state.vpc -D -y -i "subnet_private"
terrahub configure -c component.template.data.terraform_remote_state.vpc.backend="s3" -i "subnet_private"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.bucket="data-lake-terrahub-us-east-1" -i "subnet_private"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.region="us-east-1" -i "subnet_private"
terrahub configure -c component.template.data.terraform_remote_state.vpc.config.key="terraform/terrahubcorp/demo-terraform-automation-aws/vpc/terraform.tfstate" -i "subnet_private"
terrahub configure -c component.template.terraform.backend -D -y -i "vpc"
terrahub configure -c component.template.terraform.backend.s3.key="terraform/terrahubcorp/demo-terraform-automation-aws/vpc/terraform.tfstate" -i "vpc"

terrahub run -y -b ${THUB_APPLY} ${GIT_DIFF}
