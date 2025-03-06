data "aws_iam_policy_document" "assume_role_policy" {
    statement {
        effect = "Allow"

        actions = ["sts:AssumeRole"]

        principals {
            type = "Service"
            identifiers = ["lambda.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "saa_lambda_role" {
    name = "${var.function_name}-role"
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "archive_file" "function_file" {
    type = "zip"
    source_file = var.function_file_path
    # Within this zip name file, actual function code resides with its own name
    output_path = "${path.module}/${var.function_name}.zip"  
}

resource "aws_lambda_function" "saa_lambda" {
    function_name = var.function_name
    role = aws_iam_role.saa_lambda_role.arn
    # This is very important {function file name without .py}
    handler = "${var.code_file_name}.lambda_handler"   
    runtime = var.lambda_runtime
    filename = "${path.module}/${var.function_name}.zip"

    # This helps terraform track the function's code and updates the function when the code changes
    source_code_hash = data.archive_file.function_file.output_base64sha256

}

# Policy to access Dynamodb table
data "aws_iam_policy_document" "access_dynamodb" {
    statement {
        effect = "Allow"

        actions = [
            "dynamodb:GetItem",
            "dynamodb:PutItem"
        ]

        resources = var.table_arns
    }
}

# Create a managed IAM policy to access the dynamodb table
resource "aws_iam_policy" "access_dynamodb" {
    name = "${var.function_name}-dynamodb-policy"
    policy = data.aws_iam_policy_document.access_dynamodb.json
}

# Attach the policy to the lambda role
resource "aws_iam_role_policy_attachment" "dynamodb_access" {
    role = aws_iam_role.saa_lambda_role.name
    policy_arn = aws_iam_policy.access_dynamodb.arn
}
