resource "aws_iam_user" "dev_ops_user1" {
  name          = "${var.iam_user_name}"
  path          = "${var.iam_user_path}"
  force_destroy = "${var.iam_user_force_destroy}"
}
