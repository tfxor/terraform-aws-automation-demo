# Define list of variables to be output

output "user" {
  value = "${aws_iam_user_group_membership.iam_user_group_membership.user}"
}

output "groups" {
  value = "${aws_iam_user_group_membership.iam_user_group_membership.groups}"
}
