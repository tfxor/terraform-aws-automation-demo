resource "aws_iam_user" "iam_user" {
  name          = "${var.iam_user_name}"
  path          = "${var.iam_user_path}"
  force_destroy = "${var.iam_user_force_destroy}"
}
