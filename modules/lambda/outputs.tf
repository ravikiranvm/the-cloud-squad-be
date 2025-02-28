output "function_arn" {
  value = aws_lambda_function.saa_lambda.arn
  description = "this will be useful to use in the api gateway resource"
}

output "function_name" {
  value = aws_lambda_function.saa_lambda.function_name
  description = "this will be useful to use in the api gateway resource"
}