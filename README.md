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
terrahub component -t aws_lambda_function -n lambda -o ../iam_role,../security_group,../subnet_private
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

## Customize TerraHub Component for VPC

Run the following command in terminal:
```shell
terrahub configure -i vpc -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/vpc/terraform.tfstate'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.assign_generated_ipv6_cidr_block='true'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.cidr_block='11.0.0.0/23'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.enable_classiclink='false'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.enable_classiclink_dns_support='false'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.enable_dns_hostnames='true'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.enable_dns_support='true'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.instance_tenancy='default'
terrahub configure -i vpc -c component.template.resource.aws_vpc.vpc.tags='${map("Description","Managed by TerraHub", "Name","demo-terraform-automation-aws", "ThubCode","7356626c", "ThubEnv","default")}'
terrahub configure -i vpc -c component.template.variable -D -y
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for Subnet

Run the following command in terminal:
```shell
terrahub configure -i subnet_private -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/subnet_private/terraform.tfstate'
terrahub configure -i subnet_private -c component.template.data.aws_availability_zones.az={}
terrahub configure -i subnet_private -c component.template.data.terraform_remote_state.vpc.backend='local'
terrahub configure -i subnet_private -c component.template.data.terraform_remote_state.vpc.config.path='/tmp/.terrahub/local_backend/vpc/terraform.tfstate'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.count='${length(data.aws_availability_zones.az.names)}'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.assign_ipv6_address_on_creation='false'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.availability_zone='${element(data.aws_availability_zones.az.names, count.index)}'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.vpc_id='${data.terraform_remote_state.vpc.thub_id}'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.cidr_block='${cidrsubnet("11.0.1.0/24", 4, count.index)}'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.map_public_ip_on_launch='false'
terrahub configure -i subnet_private -c component.template.resource.aws_subnet.subnet_private.tags='${map("Description","Managed by TerraHub", "Name","demo-terraform-automation-aws", "ThubCode","7356626c", "ThubEnv","default")}'
terrahub configure -i subnet_private -c component.template.variable -D -y
terrahub configure -i subnet_private -c component.template.output -D -y
terrahub configure -i subnet_private -c component.template.output.id.value='${aws_subnet.subnet_private.*.id}'
terrahub configure -i subnet_private -c component.template.output.thub_id.value='${aws_subnet.subnet_private.*.id}'
terrahub configure -i subnet_private -c component.template.output.availability_zone.value='${aws_subnet.subnet_private.*.availability_zone}'
terrahub configure -i subnet_private -c component.template.output.cidr_block.value='${aws_subnet.subnet_private.*.cidr_block}'
terrahub configure -i subnet_private -c component.template.output.vpc_id.value='${aws_subnet.subnet_private.*.vpc_id}'
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for Security Group

Run the following command in terminal:
```shell
terrahub configure -i security_group -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/security_group/terraform.tfstate'
terrahub configure -i security_group -c component.template.data.terraform_remote_state.vpc.backend='local'
terrahub configure -i security_group -c component.template.data.terraform_remote_state.vpc.config.path='/tmp/.terrahub/local_backend/vpc/terraform.tfstate'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.description='default VPC security group'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.name='demo-terraform-automation-aws'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.vpc_id='${data.terraform_remote_state.vpc.thub_id}'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.egress[0]='${map("description","default VPC security group", "from_port","0", "protocol","-1", "self","true", "to_port","0")}'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.ingress[0]='${map("description","default VPC security group", "from_port","0", "protocol","-1", "self","true", "to_port","0")}'
terrahub configure -i security_group -c component.template.resource.aws_security_group.security_group.tags='${map("Description","Managed by TerraHub", "Name","demo-terraform-automation-aws", "ThubCode","7356626c", "ThubEnv","default")}'
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for IAM Role

Run the following command in terminal:
```shell
terrahub configure -i iam_role -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/iam_role/terraform.tfstate'
terrahub configure -i iam_role -c component.template.data.template_file.iam_role_policy.template='${file("${local.project["path"]}/iam_role_policy.json.tpl")}'
terrahub configure -i iam_role -c component.template.data.template_file.iam_role_policy.vars='${map("account_id","${local.account_id}")}'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role.iam_role.assume_role_policy='${file("${local.project["path"]}/iam_trust_policy.json")}'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role.iam_role.description='Managed by TerraHub'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role.iam_role.force_detach_policies='false'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role.iam_role.name='DemoLambdaAWSExec7356626c'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role.iam_role.path='/'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role_policy.iam_role.name='DemoLambdaAWSExecPolicy7356626c'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role_policy.iam_role.policy='${data.template_file.iam_role_policy.rendered}'
terrahub configure -i iam_role -c component.template.resource.aws_iam_role_policy.iam_role.role='${aws_iam_role.iam_role.id}'
terrahub configure -i iam_role -c component.template.variable -D -y
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for Lambda

Run the following command in terminal:
```shell
terrahub configure -i lambda -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/lambda/terraform.tfstate'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.iam.backend='local'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.iam.config.path='/tmp/.terrahub/local_backend/iam_role/terraform.tfstate'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.subnet.backend='local'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.subnet.config.path='/tmp/.terrahub/local_backend/subnet_private/terraform.tfstate'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.sg.backend='local'
terrahub configure -i lambda -c component.template.data.terraform_remote_state.sg.config.path='/tmp/.terrahub/local_backend/security_group/terraform.tfstate'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.filename='${local.component["path"]}/demo.zip'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.description='Managed by TerraHub'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.function_name='DemoLambda7356626c'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.memory_size='512'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.publish='false'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.role='${data.terraform_remote_state.iam.arn}'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.runtime='nodejs8.10'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.source_code_hash='${base64sha256(file("${local.component["path"]}/demo.zip"))}'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.handler='demo.handler'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.timeout='300'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.vpc_config.security_group_ids[0]='${data.terraform_remote_state.sg.thub_id}'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.vpc_config.subnet_ids[0]='${data.terraform_remote_state.subnet.thub_id}'
terrahub configure -i lambda -c component.template.resource.aws_lambda_function.lambda.tags='${map("Description","Managed by TerraHub", "Name","demo-terraform-automation-aws", "ThubCode","7356626c", "ThubEnv","default")}'
terrahub configure -i lambda -c component.template.variable -D -y
terrahub configure -i lambda -c build.env.variables.THUB_ENV='dev'
terrahub configure -i lambda -c build.env.variables.THUB_LAMBDA_ZIP='demo.zip'
terrahub configure -i lambda -c build.env.variables.THUB_BUILD_PATH='..'
terrahub configure -i lambda -c build.env.variables.THUB_BUILD_OK='true'
terrahub configure -i lambda -c build.phases.post_build.commands[0]='echo "BUILD: Running post_build step"'
terrahub configure -i lambda -c build.phases.post_build.commands[1]='./scripts/zip.sh $THUB_LAMBDA_ZIP $THUB_BUILD_PATH/demo.js'
terrahub configure -i lambda -c build.phases.post_build.finally[0]='echo "BUILD: post_build step successful"'
```

Your output should be similar to the one below:
```
✅ Done
```

## Customize TerraHub Component for API Gateway RestAPI

Run the following command in terminal:
```shell
terrahub configure -i api_gateway_rest_api -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/api_gateway_rest_api/terraform.tfstate'
terrahub configure -i api_gateway_rest_api -c component.template.data.template_file.swagger.template='${file("${local.project["path"]}/api_swagger.json.tpl")}'
terrahub configure -i api_gateway_rest_api -c component.template.data.template_file.swagger.vars='${map("account_id","${local.account_id}")}'
terrahub configure -i api_gateway_rest_api -c component.template.resource.aws_api_gateway_rest_api.api_gateway_rest_api.body='${data.template_file.swagger.rendered}}'
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
terrahub configure -i api_gateway_deployment -c component.template.terraform.backend.local.path='/tmp/.terrahub/local_backend/api_gateway_deployment/terraform.tfstate'
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
Project: demo-terraform-automation-aws
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
terrahub build -i=lambda
terrahub run -a -y
```

## Run Test Command

Run the following command in terminal:
```
curl https://xxxxxxxxxx.execute-api.us-east-1.amazonaws.com/demo
```
