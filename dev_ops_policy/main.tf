resource "aws_iam_policy" "dev_ops_policy" {
  name        = "${var.iam_policy_name}"
  description = "${var.iam_policy_description}"
  path        = "${var.iam_policy_path}"
  policy      = "${data.aws_iam_policy_document.statement.json}"
}
