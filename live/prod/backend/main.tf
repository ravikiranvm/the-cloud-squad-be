module "SAADynamoDBTable" {
  source        = "../../../modules/data-stores/dy-db"
  tableName = "SAAQuestionBank"
  primary_key = "id"
  primary_key_type = "N"
  sort_key = null
}

module "scores" {
  source = "../../../modules/data-stores/dy-db"
  tableName = "Scores"
  primary_key = "session_id"
  primary_key_type = "S"
  sort_key = "user_name"
  sort_key_type = "S"
}

module "reviews" {
  source = "../../../modules/data-stores/dy-db"
  tableName = "Reviews"
  primary_key = "session_id"
  primary_key_type = "S"
  sort_key = "date"
  sort_key_type = "S"
}

# Lambda Function to retrieve SAA questions from the SAA Dy DB table
module "SAAQuestionRetriever" {
  source             = "../../../modules/lambda"
  function_name      = "saa-question-retriever"
  function_file_path = "../../../scripts/table_get.py"
  table_arns          = [module.SAADynamoDBTable.SaaQTableARN, module.scores.SaaQTableARN, module.reviews.SaaQTableARN]
  lambda_runtime     = "python3.13"
  code_file_name     = "table_get"
}

# API gateway
module "saa_api" {
  source = "../../../modules/api"
  stage  = "prod"
  lambda_arn  = module.SAAQuestionRetriever.function_arn
  function_name = module.SAAQuestionRetriever.function_name
}