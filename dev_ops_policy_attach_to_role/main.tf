resource "aws_iam_role_policy_attachment" "dev_ops_policy_attach_to_role" {
  role       = "${var.iam_role_name}"
  policy_arn = "arn:aws:iam::${var.account_id}:policy/${var.iam_policy_name}"
}
