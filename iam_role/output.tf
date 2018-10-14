# Define list of variables to be output

output "arn" {
  value = "${aws_iam_role.iam_role.arn}"
}

output "create_date" {
  value = "${aws_iam_role.iam_role.create_date}"
}

output "unique_id" {
  value = "${aws_iam_role.iam_role.unique_id}"
}

output "name" {
  value = "${aws_iam_role.iam_role.name}"
}

output "description" {
  value = "${aws_iam_role.iam_role.description}"
}
