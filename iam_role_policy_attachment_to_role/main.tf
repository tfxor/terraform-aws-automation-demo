resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment_to_role" {
  role       = "${var.iam_role_name}"
  policy_arn = "arn:aws:iam::${var.account_id}:policy/${var.iam_policy_name}"
}
