resource "aws_iam_group" "dev_ops_group" {
  name     = "${var.iam_group_name}"
  path     = "${var.iam_group_path}"
}
