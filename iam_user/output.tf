# Define list of variables to be output

output "arn" {
  value = "${aws_iam_user.iam_user.arn}"
}

output "name" {
  value = "${aws_iam_user.iam_user.name}"
}

output "unique_id" {
  value = "${aws_iam_user.iam_user.unique_id}"
}
