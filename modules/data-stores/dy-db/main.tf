# Dynamo DB table stores the SAA question bank.
# The attribute "option" is a string type buy stored as a list in the table.

resource "aws_dynamodb_table" "SAA-Question-Bank-Table" {
    name = var.tableName
    billing_mode = "PAY_PER_REQUEST"

    hash_key = var.primary_key 
    range_key = var.sort_key
    
    attribute {
        name = var.primary_key        
        type = var.primary_key_type     
    }

    # Conditionally set the sort key attribute
    dynamic "attribute" {
        for_each = var.sort_key != null ? [var.sort_key] : []
        content {
            name = var.sort_key
            type = var.sort_key_type
        }
    }
}