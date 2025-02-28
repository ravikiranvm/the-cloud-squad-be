variable "lambda_arn" {
    description = "The ARN of the Lambda function to integrate with the API Gateway"
    type = string
}
/*
variable "stage_name" {
    description = "The name of the stage to deploy the API Gateway to"
    type = string
}
*/
variable "function_name" {
    description = "The name of the Lambda function to integrate with the API Gateway"
    type = string
}

variable "stage" {
    description = "The stage to deploy the API Gateway to. Ex: stage, prod."
    type = string
}
