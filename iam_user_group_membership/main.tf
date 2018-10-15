resource "aws_iam_user_group_membership" "iam_user_group_membership" {
  user = "${var.iam_user_name}"
  groups = [
    "${var.iam_groups_name}"
  ]
}
