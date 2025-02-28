output "SaaQTableARN" {
  value = module.SAADynamoDBTable.SaaQTableARN
}

output "SaaQuestionRetrieverFunctionARN" {
  value = module.SAAQuestionRetriever.function_arn
}
output "saa_api_id" {
  value = module.saa_api.api_id
  description = "This is the invoke URL of the API Gateway"
}