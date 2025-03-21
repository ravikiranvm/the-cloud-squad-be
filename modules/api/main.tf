resource "aws_apigatewayv2_api" "saa_api" {
    name = "saa-api-${var.stage}"
    protocol_type = "HTTP"

    cors_configuration {
        allow_methods = ["GET", "POST", "PUT"]
        allow_origins = ["*"]
        allow_headers = ["Content-Type"]
    }
}

# Route to register the new user
resource "aws_apigatewayv2_route" "create_user" {
    api_id = aws_apigatewayv2_api.saa_api.id
    route_key = "POST /create-user"
    target = "integrations/${aws_apigatewayv2_integration.saa_api_integration.id}"
}

resource "aws_apigatewayv2_route" "get_saa_questions" {
    api_id = aws_apigatewayv2_api.saa_api.id
    route_key = "GET /saa-questions"
    target = "integrations/${aws_apigatewayv2_integration.saa_api_integration.id}"
}

resource "aws_apigatewayv2_route" "post_test" {
    api_id = aws_apigatewayv2_api.saa_api.id
    route_key = "POST /submit-test"
    target = "integrations/${aws_apigatewayv2_integration.saa_api_integration.id}"
}

resource "aws_apigatewayv2_route" "tests_taken" {
    api_id = aws_apigatewayv2_api.saa_api.id
    route_key = "GET /tests-taken"
    target = "integrations/${aws_apigatewayv2_integration.saa_api_integration.id}"
}

resource "aws_apigatewayv2_route" "add_review" {
    api_id = aws_apigatewayv2_api.saa_api.id
    route_key = "POST /add-review"
    target = "integrations/${aws_apigatewayv2_integration.saa_api_integration.id}"
}

#One Lambda function integration to all the routes
resource "aws_apigatewayv2_integration" "saa_api_integration" {
    api_id = aws_apigatewayv2_api.saa_api.id
    integration_type = "AWS_PROXY"
    integration_uri = var.lambda_arn
    payload_format_version = "2.0"
}

resource "aws_apigatewayv2_stage" "stage" {
    api_id = aws_apigatewayv2_api.saa_api.id
    name = "${var.stage}"
    auto_deploy = true
}

# Permission to invoke lambda function
resource "aws_lambda_permission" "apigw_lambda" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = var.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.saa_api.execution_arn}/*/*"
}
