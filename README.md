# Terraform Demo using AWS provider

## Create IAM User
```shell
1. Sign in to the AWS Management Console and open the IAM console at https://console.aws.amazon.com/iam/.
2. In the navigation pane, choose Users and then choose Add user.
3. Type the user name for the new user.
4. Select the type of access: `Programmatic access`.
5. Choose `Next`: Permissions.
6. On the Set permissions page, choose `Attach existing policies to user directly` and select `IAMFullAccess`.
7. Choose Next: Review to see all of the choices you made up to this point.
8. Choose `Create`
```

## Get Access Key ID and Secret Access Key for IAM User
```shell
1. Open the IAM console
2. In the navigation pane of the console, choose Users.
3. Choose your IAM user name (not the check box).
4. Choose the Security credentials tab and then choose Create access key.
5. To see the new access key, choose Show. Your credentials will look something like this:
  - Access key ID: AKIAIOSFODNN7EXAMPLE
  - Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

## Config AWS CLI
```shell
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

## Get Default Values for ACCOUNT_ID and REGION_ID
```shell
aws sts get-caller-identity --output text --query 'Account'
aws configure get region
```

## Setup AWS Cloud ENV Variables
```shell
export AWS_ACCOUNT_ID=""     ## e.g. 123456789012
export AWS_DEFAULT_REGION="" ## e.g. us-east-1
```

## Create TerraHub Project
```shell
mkdir demo-terraform-aws
cd demo-terraform-aws
terrahub project -n demo-terraform-aws
```

## Create TerraHub Component
```shell
terrahub component -t aws_iam_role -n iam_role
terrahub component -t aws_iam_policy -n iam_policy -o ../iam_role
terrahub component -t aws_iam_role_policy_attachment -n iam_role_policy_attachment_to_role -o ../iam_policy
terrahub component -t aws_iam_group -n iam_group -o ../iam_policy
terrahub component -t aws_iam_group_policy_attachment -n iam_role_policy_attachment_to_group  -o ../iam_group
terrahub component -t aws_iam_user -n iam_user -o ../iam_group
terrahub component -t aws_iam_user_group_membership -n iam_user_group_membership -o ../iam_user
```

## Update TerraHub Component Config
```shell
terrahub configure -c terraform.var.account_id="${AWS_ACCOUNT_ID}"
terrahub configure -c terraform.var.region="${AWS_DEFAULT_REGION}"
```

## Execute TerraHub Component
```shell
terrahub run -a -y
```

## Components graph
```shell
Project: demo-terraform-aws
 └─ iam_role [path: ./iam_role]
    └─ iam_policy [path: ./iam_policy]
       ├─ iam_group [path: ./iam_group]
       │  ├─ iam_role_policy_attachment_to_group [path: ./iam_role_policy_attachment_to_group]
       │  └─ iam_user [path: ./iam_user]
       │     └─ iam_user_group_membership [path: ./iam_user_group_membership]
       └─ iam_role_policy_attachment_to_role [path: ./iam_role_policy_attachment_to_role]
```
