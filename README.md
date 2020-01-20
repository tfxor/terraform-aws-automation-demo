# Terraform Automation Demo using AWS Cloud Provider

The purpose of this repository is to show case terraform automation for AWS
Cloud. This demo will provision the following cloud resources associated to
corresponding terraform configurations:

| AWS Resource | Terraform Resource | Link to TerraHub Config |
|-----------------------|--------------------|-------------------------|
| API Gateway Deployment | aws_api_gateway_deployment | [api_gateway_deployment/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/api_gateway_deployment/.terrahub.yml#L2) |
| API Gateway REST API | aws_api_gateway_rest_api | [api_gateway_rest_api/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/api_gateway_rest_api/.terrahub.yml#L2) |
| IAM Role | aws_iam_role | [iam_role/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/iam_role/.terrahub.yml#L2) |
| Lambda Function | aws_lambda_function | [lambda/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/lambda/.terrahub.yml#L2) |
| Security Group | aws_security_group | [security_group/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/security_group/.terrahub.yml#L2) |
| Subnet | aws_subnet | [subnet_private/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/subnet_private/.terrahub.yml#L2) |
| VPC | aws_vpc | [vpc/.terrahub.yml#L2](https://github.com/TerraHubCorp/terraform-aws-automation-demo/blob/master/vpc/.terrahub.yml#L2) |

Follow below instructions to try this out in your own AWS Cloud account.

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

Manual Setup (set values in double quotes and run the following commands in terminal):
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

## Terraform Automation and Orchestration Tool

The next couple of paragraphs are showcasing the process of creating terrahub
automation process using [TerraHub CLI](https://github.com/TerraHubCorp/terrahub).

Run the following commands in terminal:
```shell
terrahub --help | head -3
```

Your output should be similar to the one below:
```
Usage: terrahub [command] [options]

terrahub@0.0.1 (built: 2018-04-14T19:15:39.787Z)
```

> NOTE: If you don't have TerraHub CLI, check out this
[installation guide](https://www.npmjs.com/package/terrahub)

## Configure Terraform Automation using TerraHub

Run the following commands in terminal:
```shell
git clone https://github.com/TerraHubCorp/terraform-aws-automation-demo.git
cd terraform-aws-automation-demo
rm **/.terrahub.yml
terrahub component -n api_gateway_deployment -d ./api_gateway_deployment
terrahub component -n api_gateway_rest_api -d ./api_gateway_rest_api
terrahub component -n iam_role -d ./iam_role
terrahub component -n lambda -d ./lambda
terrahub component -n security_group -d ./security_group
terrahub component -n subnet_private -d ./subnet_private
terrahub component -n vpc -d ./vpc
```

Your output should be similar to the one below:
```
✅ Component successfully created
```

## Configure Dependencies between TerraHub Components

Run the following commands in terminal:
```shell
terrahub configure -i api_gateway_deployment -c component.dependsOn[]='api_gateway_rest_api'
terrahub configure -i api_gateway_rest_api -c component.dependsOn[]='lambda'
terrahub configure -i lambda -c component.dependsOn[]='iam_role'
terrahub configure -i lambda -c component.dependsOn[]='security_group'
terrahub configure -i lambda -c component.dependsOn[]='subnet_private'
terrahub configure -i security_group -c component.dependsOn[]='vpc'
terrahub configure -i subnet_private -c component.dependsOn[]='vpc'
```

Your output should be similar to the one below:
```
✅ Done
```

## Configure Active AWS Account and AWS Region

Run the following commands in terminal:
```shell
terrahub configure -c template.locals.account_id="${AWS_ACCOUNT_ID}"
terrahub configure -c template.locals.region="${AWS_DEFAULT_REGION}"
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
Project: terraform-aws-automation-demo
 ├─ iam_role [path: ./iam_role]
 │  └─ lambda [path: ./lambda]
 │     └─ api_gateway_rest_api [path: ./api_gateway_rest_api]
 │        └─ api_gateway_deployment [path: ./api_gateway_deployment]
 └─ vpc [path: ./vpc]
    ├─ security_group [path: ./security_group]
    └─ subnet_private [path: ./subnet_private]
```

## Run TerraHub Automation

Run the following command in terminal:

```shell
terrahub run -y -a -b
```

Your output should be similar to the one below:
```
💡 THUB_TOKEN is not provided.
Project: terraform-aws-automation-demo | Components: api_gateway_deployment, api_gateway_rest_api, iam_role, lambda, security_group, subnet_private, vpc
Option 'auto-approve' is enabled, therefore 'run' action is executed with no confirmation.
💡 [iam_role] terraform init -no-color -force-copy -input=false .

[[REDACTED]]

[api_gateway_deployment] State path: /tmp/.terrahub/local_backend/terraform-aws-automation-demo/api_gateway_deployment/terraform.tfstate

Outputs:

[api_gateway_deployment] execution_arn = arn:aws:execute-api:us-east-1:[[REDACTED]]:[[REDACTED]]/demo
[api_gateway_deployment] id = [[REDACTED]]
[api_gateway_deployment] invoke_url = https://[[REDACTED]].execute-api.us-east-1.amazonaws.com/demo
✅ Done
```

## Test Deployed Cloud Resources

Check if backend was deployed successfully. Run the following command in terminal (replace `[[REDACTED]]` with your value):
```
curl https://[[REDACTED]].execute-api.us-east-1.amazonaws.com/demo
```

> NOTE: If you receive `{"message": "Internal server error"}`, wait couple of seconds/minutes and try again.
