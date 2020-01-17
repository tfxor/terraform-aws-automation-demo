resource "aws_lambda_function" "lambda" {
  memory_size      = 512
  publish          = false
  source_code_hash = base64sha256(format("%s/demo.zip", local.component["path"]))
  vpc_config {
    security_group_ids = [
      data.terraform_remote_state.sg.outputs.thub_id
    ]
    subnet_ids = data.terraform_remote_state.subnet.outputs.thub_id
  }
  function_name = "DemoAWSLambda7356626c"
  handler       = "demo.handler"
  runtime       = "nodejs12.x"
  description   = "Managed by TerraHub"
  tags = map("Description", "Managed by TerraHub",
    "Name", "demo-terraform-automation-aws", "ThubCode", "7356626c",
  "ThubEnv", "default")
  role     = data.terraform_remote_state.iam.outputs.arn
  filename = format("%s/demo.zip", local.component["path"])
  timeout  = 300
}
