resource "aws_api_gateway_rest_api" "api_gateway_rest_api" {
  body        = data.template_file.swagger.rendered
  description = "Managed by TerraHub"
  name        = "DemoApi7356626c"
}
