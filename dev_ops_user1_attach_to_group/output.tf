# Define list of variables to be output

output "user" {
  value = "${aws_iam_user_group_membership.dev_ops_user1_attach_to_group.user}"
}

output "groups" {
  value = "${aws_iam_user_group_membership.dev_ops_user1_attach_to_group.groups}"
}