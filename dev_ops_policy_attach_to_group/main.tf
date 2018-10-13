resource "aws_iam_group_policy_attachment" "dev_ops_policy_attach_to_group" {
  group      = "${var.iam_group_name}"
  policy_arn = "arn:aws:iam::${var.account_id}:policy/${var.iam_policy_name}"
}