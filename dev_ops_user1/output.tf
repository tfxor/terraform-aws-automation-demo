# Define list of variables to be output

output "arn" {
  value = "${aws_iam_user.dev_ops_user1.arn}"
}

output "name" {
  value = "${aws_iam_user.dev_ops_user1.name}"
}

output "unique_id" {
  value = "${aws_iam_user.dev_ops_user1.unique_id}"
}
