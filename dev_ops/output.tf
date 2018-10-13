# Define list of variables to be output

output "arn" {
  value = "${aws_iam_role.dev_ops.arn}"
}

output "create_date" {
  value = "${aws_iam_role.dev_ops.create_date}"
}

output "unique_id" {
  value = "${aws_iam_role.dev_ops.unique_id}"
}

output "name" {
  value = "${aws_iam_role.dev_ops.name}"
}

output "description" {
  value = "${aws_iam_role.dev_ops.description}"
}
