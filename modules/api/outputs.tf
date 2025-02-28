output "api_id" {
    value = aws_apigatewayv2_api.saa_api.id
    description = "This is the invoke URL of the API Gateway"
}