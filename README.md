# Terraform Demo using AWS provider

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

## Get Values for Your AWS Account

Run the following command in terminal:
```shell
aws sts get-caller-identity --output text --query 'Account'
```

Your output should be similar to the one below:
```
123456789012
```

Run the following command in terminal:
```shell
aws configure list
```

Your output should be similar to the one below:
```
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************LEID shared-credentials-file
secret_key     ****************EKEY shared-credentials-file
    region                us-east-1      config-file    /home/demo/.aws/config
```

## Setup Environment Variables (Will Be Used Later)

Manual Setup (set values in double quotes and run the following command in terminal):
```shell
export AWS_ACCOUNT_ID=""     ## e.g. 123456789012
export AWS_DEFAULT_REGION="" ## e.g. us-east-1
```

Automated Setup (run the following command in terminal):
```shell
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output text --query 'Account')"
export AWS_DEFAULT_REGION="$(aws configure get region)"
```

## Create Terraform Configurations Using TerraHub

Run the following commands in terminal:
```shell
terrahub --help | head -3
```

Your output should be similar to the one below:
```
Usage: terrahub [command] [options]

terrahub@0.0.28 (built: 2018-10-11T12:33:57.775Z)
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

## Create TerraHub Components

Run the following command in terminal:
```shell
terrahub component -t aws_iam_role -n iam_role
terrahub component -t aws_iam_policy -n iam_policy -o ../iam_role
terrahub component -t aws_iam_role_policy_attachment -n iam_role_policy_attachment_to_role -o ../iam_policy
terrahub component -t aws_iam_group -n iam_group -o ../iam_policy
terrahub component -t aws_iam_group_policy_attachment -n iam_role_policy_attachment_to_group  -o ../iam_group
terrahub component -t aws_iam_user -n iam_user -o ../iam_group
terrahub component -t aws_iam_user_group_membership -n iam_user_group_membership -o ../iam_user
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

## Update Project Config

Run the following command in terminal:
```shell
terrahub configure -c terraform.var.account_id="${AWS_ACCOUNT_ID}"
terrahub configure -c terraform.var.region="${AWS_DEFAULT_REGION}"
```

Your output should be similar to the one below:
```
✅ Done
```

## Run TerraHub Automation

Run the following command in terminal:
```shell
terrahub run -a -y
```

Your output should be similar to the one below:
```
```
