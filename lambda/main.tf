resource "aws_lambda_function" "lambda" {
  function_name    = "DemoAWSLambda7356626c"
  description      = "Managed by TerraHub"
  role             = data.terraform_remote_state.iam.outputs.arn
  timeout          = 300
  memory_size      = 512
  runtime          = "nodejs12.x"
  handler          = "demo.handler"
  publish          = false
  source_code_hash = base64sha256(format("%s/demo.zip", local.component["path"]))
  filename         = format("%s/demo.zip", local.component["path"])

  tags = {
    Description = "Managed by TerraHub",
    Name        = "demo-terraform-automation-aws"
    ThubCode    = "7356626c",
    ThubEnv     = "default"
  }

  vpc_config {
    security_group_ids = [
      data.terraform_remote_state.sg.outputs.thub_id
    ]
    subnet_ids = data.terraform_remote_state.subnet.outputs.thub_id
  }
}
