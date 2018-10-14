resource "aws_iam_group" "iam_group" {
  name     = "${var.iam_group_name}"
  path     = "${var.iam_group_path}"
}
