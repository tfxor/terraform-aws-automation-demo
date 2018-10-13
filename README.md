# Terraform Demo using AWS provider

## To create IAM user
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

## To get the access key ID and secret access key for an IAM user
```shell
1. Open the IAM console
2. In the navigation pane of the console, choose Users.
3. Choose your IAM user name (not the check box).
4. Choose the Security credentials tab and then choose Create access key.
5. To see the new access key, choose Show. Your credentials will look something like this:
  - Access key ID: AKIAIOSFODNN7EXAMPLE
  - Secret access key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

## To config cli access
```shell
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

## Get AWS Cloud default values for ACCOUNT_ID and REGION_ID
```shell
aws sts get-caller-identity --output text --query 'Account'
aws configure get region
```

## Setup Google Cloud ENV Variables
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
terrahub component -t aws_iam_role -n dev_ops
terrahub component -t aws_iam_policy -n dev_ops_policy -o ../dev_ops
terrahub component -t aws_iam_role_policy_attachment -n dev_ops_policy_attach_to_role -o ../dev_ops_policy
terrahub component -t aws_iam_group -n dev_ops_group -o ../dev_ops_policy
terrahub component -t aws_iam_group_policy_attachment -n dev_ops_policy_attach_to_group  -o ../dev_ops_group
terrahub component -t aws_iam_user -n dev_ops_user1 -o ../dev_ops_group
terrahub component -t aws_iam_user_group_membership -n dev_ops_user1_attach_to_group -o ../dev_ops_user1
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
 └─ dev_ops [path: ./dev_ops]
    └─ dev_ops_policy [path: ./dev_ops_policy]
       ├─ dev_ops_group [path: ./dev_ops_group]
       │  ├─ dev_ops_policy_attach_to_group [path: ./dev_ops_policy_attach_to_group]
       │  └─ dev_ops_user1 [path: ./dev_ops_user1]
       │     └─ dev_ops_user1_attach_to_group [path: ./dev_ops_user1_attach_to_group]
       └─ dev_ops_policy_attach_to_role [path: ./dev_ops_policy_attach_to_role]
```
