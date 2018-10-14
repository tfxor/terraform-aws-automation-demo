# Define list of variables to be output

output "id" {
  value = "${aws_iam_group.iam_group.id}"
}

output "thub_id" {
  value = "${aws_iam_group.iam_group.id}"
}

output "arn" {
  value = "${aws_iam_group.iam_group.arn}"
}

output "name" {
  value = "${aws_iam_group.iam_group.name}"
}

output "path" {
  value = "${aws_iam_group.iam_group.path}"
}

output "unique_id" {
  value = "${aws_iam_group.iam_group.unique_id}"
}
