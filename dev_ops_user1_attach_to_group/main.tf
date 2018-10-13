resource "aws_iam_user_group_membership" "dev_ops_user1_attach_to_group" {
  user = "${var.iam_user_name}"
  groups = [
    "${var.iam_groups_name}"
  ]
}