resource "aws_lambda_function" "lambda" {
  function_name    = "DemoAWSLambda7356626c"
  description      = "Managed by TerraHub"
  role             = lookup(data.terraform_remote_state.iam.outputs, "arn", "Is not set!")
  timeout          = 300
  memory_size      = 512
  runtime          = "nodejs12.x"
  handler          = "demo.handler"
  publish          = false
  source_code_hash = base64sha256(format("%s/demo.zip", local.component["path"]))
  filename         = format("%s/demo.zip", local.component["path"])

  tags = {
    Description = "Managed by TerraHub",
    Name        = "terraform-aws-automation-demo"
    ThubCode    = "7356626c",
    ThubEnv     = "default"
  }

  vpc_config {
    security_group_ids = [
      lookup(data.terraform_remote_state.sg.outputs, "thub_id", "Is not set!")
    ]
    subnet_ids = lookup(data.terraform_remote_state.subnet.outputs, "thub_id", "Is not set!")
  }
}
