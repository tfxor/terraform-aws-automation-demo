data "aws_iam_policy_document" "iam_policy" {
  statement {
  	sid       = "${var.iam_policy_sid}"
    actions   = "${split(",",var.iam_policy_actions)}"
    resources = "${split(",",var.iam_policy_resources)}"
  }
}
