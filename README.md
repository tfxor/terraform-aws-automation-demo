# Terraform Automation using AWS Provider

## Create IAM User
1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/
2. In the navigation pane, choose Users and then choose Add user
3. Type the user name for the new user
4. Select the type of access: `Programmatic access`
5. Choose `Next`: Permissions
6. On the Set permissions page, choose `Attach existing policies to user directly` and select `IAMFullAccess`
7. Choose Next: Review to see all of the choices you made up to this point
8. Choose `Create`

## Get Access Key ID and Secret Access Key for IAM User
1. Open the IAM console
2. In the navigation pane of the console, choose Users
3. Choose your IAM user name (not the check box)
4. Choose the Security credentials tab and then choose Create access key
5. To see the new access key, choose Show. Your credentials will look something like this:
  - Access Key ID: AKIAIOSFODNEXAMPLEID
  - Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

## Configure AWS CLI with IAM Credentials

Run the following command in terminal:
```shell
aws configure
```

Your output should be similar to the one below:
```
AWS Access Key ID [None]: AKIAIOSFODNEXAMPLEID
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

> NOTE: If you don't have AWS CLI, check out
[installation guide](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)

## Setup Environment Variables (Will Be Used Later)

Manual Setup (set values in double quotes and run the following command in terminal):
```shell
export AWS_ACCOUNT_ID=""     ## e.g. 123456789012
export AWS_DEFAULT_REGION="" ## e.g. us-east-1
```

### Setup AWS_ACCOUNT_ID Programmatically

Automated Setup (run the following command in terminal):
```shell
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output=text --query='Account')"
```

### Setup AWS_DEFAULT_REGION Programmatically

Automated Setup (run the following command in terminal):
```shell
export AWS_DEFAULT_REGION="$(aws configure get region --output=text)"
```

## Create Terraform Configurations Using TerraHub

Run the following commands in terminal:
```shell
terrahub --help | head -3
```

Your output should be similar to the one below:
```
Usage: terrahub [command] [options]

terrahub@0.1.28 (built: 2019-02-08T17:17:41.912Z)
```

> NOTE: If you don't have TerraHub CLI, check out
[installation guide](https://www.npmjs.com/package/terrahub)

Run the following commands in terminal:
```shell
mkdir demo-terraform-aws
cd demo-terraform-aws
terrahub project -n demo-terraform-aws
```

Your output should be similar to the one below:
```
✅ Project successfully initialized
```

## Create TerraHub Components from Templates

Run the following command in terminal:
```shell
terrahub component -t aws_vpc -n vpc
terrahub component -t aws_subnet -n subnet_private -o ../vpc
terrahub component -t aws_security_group -n security_group -o ../vpc
terrahub component -t aws_iam_role -n iam_role
terrahub component -t aws_lambda_function -n lambda -o ../iam_role
terrahub component -t aws_api_gateway_rest_api -n api_gateway_rest_api -o ../lambda
terrahub component -t aws_api_gateway_deployment -n api_gateway_deployment -o ../api_gateway_rest_api
```

Your output should be similar to the one below:
```
✅ Done
```

## Update Project Config

Run the following command in terminal:
```shell
terrahub configure -c template.locals.account_id="${AWS_ACCOUNT_ID}"
terrahub configure -c template.locals.region="${AWS_DEFAULT_REGION}"
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for API Gateway RestAPI

Run the following command in terminal:
```shell
terrahub configure -i api_gateway_rest_api -c component.template.terraform.backend.local.path='~/.terrahub/local_backend/api_gateway_rest_api/terraform.tfstate'
terrahub configure -i api_gateway_rest_api -c component.template.data.local_file.swagger.filename='${local.project["path"]}/api-swagger.json'
terrahub configure -i api_gateway_rest_api -c component.template.resource.aws_api_gateway_rest_api.api_gateway_rest_api.body='${data.local_file.swagger.content}'
terrahub configure -i api_gateway_rest_api -c component.template.resource.aws_api_gateway_rest_api.api_gateway_rest_api.depends_on[0]='data.local_file.swagger'
terrahub configure -i api_gateway_rest_api -c component.template.resource.aws_api_gateway_rest_api.api_gateway_rest_api.description='Managed by TerraHub'
terrahub configure -i api_gateway_rest_api -c component.template.resource.aws_api_gateway_rest_api.api_gateway_rest_api.name='DemoApi7356626c'
terrahub configure -i api_gateway_rest_api -c component.template.variable -D -y
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for API Gateway Deployment

Run the following command in terminal:
```shell
terrahub configure -i api_gateway_deployment -c component.template.terraform.backend.local.path='~/.terrahub/local_backend/api_gateway_deployment/terraform.tfstate'
terrahub configure -i api_gateway_deployment -c component.template.data.aws_api_gateway_rest_api.api_gateway_deployment.name='DemoApi7356626c'
terrahub configure -i api_gateway_deployment -c component.template.resource.aws_api_gateway_deployment.api_gateway_deployment.rest_api_id='${data.aws_api_gateway_rest_api.api_gateway_deployment.id}'
terrahub configure -i api_gateway_deployment -c component.template.resource.aws_api_gateway_deployment.api_gateway_deployment.description='Managed by TerraHub'
terrahub configure -i api_gateway_deployment -c component.template.resource.aws_api_gateway_deployment.api_gateway_deployment.stage_description='${format("%s %s", var.api_gateway_deployment_stage_name, timestamp())}'
terrahub configure -i api_gateway_deployment -c component.template.resource.aws_api_gateway_deployment.api_gateway_deployment.stage_name='demo'
terrahub configure -i api_gateway_deployment -c component.template.variable.api_gateway_deployment_rest_api_id -D -y
terrahub configure -i api_gateway_deployment -c component.template.tfvars.api_gateway_deployment_stage_name='Deployed at'
```

Your output should be similar to the one below:
```
✅ Done
```

## Visualize TerraHub Components

Run the following command in terminal:
```shell
terrahub graph
```

Your output should be similar to the one below:
```
Project: demo-terraform-aws
 └─ iam_role [path: ./iam_role]
    └─ iam_policy [path: ./iam_policy]
       ├─ iam_group [path: ./iam_group]
       │  ├─ iam_role_policy_attachment_to_group [path: ./iam_role_policy_attachment_to_group]
       │  └─ iam_user [path: ./iam_user]
       │     └─ iam_user_group_membership [path: ./iam_user_group_membership]
       └─ iam_role_policy_attachment_to_role [path: ./iam_role_policy_attachment_to_role]
```

## Run TerraHub Automation

Run the following command in terminal:
```shell
terrahub run -a -y
```

Your output should be similar to the one below:
```
```
