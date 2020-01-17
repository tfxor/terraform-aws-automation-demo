resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id       = data.aws_api_gateway_rest_api.api_gateway_deployment.id
  stage_name        = "demo"
  description       = "Managed by TerraHub"
  stage_description = format("%s %s", var.api_gateway_deployment_stage_name, timestamp())
}
