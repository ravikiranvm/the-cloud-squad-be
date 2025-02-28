variable "function_name" {
    description = "Use the function namebased on its use case like get-item, put-item etc."
    type        = string
}

variable "function_file_path" {
    description = "Path to the function file containing the code for the lmabda function"
    type        = string
}

variable "table_arn" {
    description = "ARN of the dynamodb table to access"
    type        = string
}

variable "lambda_runtime" {
    description = "Runtime for the lambda function"
    type        = string
}

variable "table_region" {
    description = "Region of the dynamodb table"
    type        = string
    default = "ap-south-1"
}

variable "code_file_name" {
    description = "Input the actual file name without extension where the function's code resides."
    type        = string
}