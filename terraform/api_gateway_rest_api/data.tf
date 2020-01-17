data "template_file" "swagger" {
  template = file(format("%s/api_swagger.json.tpl", local.project["path"]))
  vars     = map("account_id", local.account_id)
}
