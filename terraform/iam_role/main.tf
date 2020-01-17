resource "aws_iam_role_policy" "iam_role" {
  name   = "DemoAWSLambdaExecPolicy7356626c"
  policy = data.template_file.iam_role_policy.rendered
  role   = aws_iam_role.iam_role.id
}
resource "aws_iam_role" "iam_role" {
  assume_role_policy    = file(format("%s/iam_trust_policy.json.tpl", local.project["path"]))
  description           = "Managed by TerraHub"
  force_detach_policies = false
  name                  = "DemoAWSLambdaExecRole7356626c"
  path                  = "/"
}
