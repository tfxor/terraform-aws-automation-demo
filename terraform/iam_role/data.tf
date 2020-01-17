data "template_file" "iam_role_policy" {
  template = file(format("%s/iam_assume_policy.json.tpl", local.project["path"]))
  vars     = map("account_id", local.account_id)
}
