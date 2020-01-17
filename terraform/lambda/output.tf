output "source_code_hash" {
  value = aws_lambda_function.lambda.source_code_hash
}

output "tracing_config" {
  value = aws_lambda_function.lambda.tracing_config
}

output "source_code_size" {
  value = aws_lambda_function.lambda.source_code_size
}

output "id" {
  value = aws_lambda_function.lambda.id
}

output "thub_id" {
  value = aws_lambda_function.lambda.id
}

output "qualified_arn" {
  value = aws_lambda_function.lambda.qualified_arn
}

output "arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}

output "version" {
  value = aws_lambda_function.lambda.version
}

output "last_modified" {
  value = aws_lambda_function.lambda.last_modified
}
