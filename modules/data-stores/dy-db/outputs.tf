output "SaaQTableARN" {
  value = aws_dynamodb_table.SAA-Question-Bank-Table.arn
  description = "Use this ARN to access the SAA Question Bank Table from the Lambda function"
}

output "table_name" {
  value = aws_dynamodb_table.SAA-Question-Bank-Table.name
  description = "Use this name to access the SAA Question Bank Table from the Lambda function"
}