# Dynamo DB table stores the SAA question bank.
# The attribute "option" is a string type buy stored as a list in the table.

resource "aws_dynamodb_table" "SAA-Question-Bank-Table" {
    name = var.SAAQTableName
    billing_mode = "PAY_PER_REQUEST"

    hash_key = "id"
    
    attribute {
        name = "id"
        type = "N"
    }

}