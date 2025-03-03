module "SAADynamoDBTable" {
  source        = "../../../modules/data-stores/dy-db"
  tableName = "SAAQuestionBank"
  primary_key = "id"
  primary_key_type = "N"
  sort_key = null
}

# Lambda Function to retrieve SAA questions from the SAA Dy DB table
module "SAAQuestionRetriever" {
  source             = "../../../modules/lambda"
  function_name      = "saa-question-retriever"
  function_file_path = "../../../scripts/table_get.py"
  table_arn          = module.SAADynamoDBTable.SaaQTableARN
  lambda_runtime     = "python3.13"
  code_file_name     = "table_get"
}

# API gateway
module "saa_api" {
  source = "../../../modules/api"
  stage  = "stage"
  lambda_arn  = module.SAAQuestionRetriever.function_arn
  function_name = module.SAAQuestionRetriever.function_name
}