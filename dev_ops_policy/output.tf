# Define list of variables to be output

output "id" {
  value = "${aws_iam_policy.dev_ops_policy.id}"
}

output "thub_id" {
  value = "${aws_iam_policy.dev_ops_policy.id}"
}

output "arn" {
  value = "${aws_iam_policy.dev_ops_policy.arn}"
}

output "name" {
  value = "${aws_iam_policy.dev_ops_policy.name}"
}

output "path" {
  value = "${aws_iam_policy.dev_ops_policy.path}"
}

output "policy" {
  value = "${aws_iam_policy.dev_ops_policy.policy}"
}
