variable "tableName" {
    type = string
    description = "The name of the question bank table. It depends on the exam type. SAA/SOA/DVA etc. SHOULD be Unique within a region."
}

variable "primary_key" {
    type = string
    description = "The primary key of the table. It is a unique identifier for each item in the table."
}

variable "primary_key_type" {
    type = string
    description = "The data type of the primary key."
    default = null
}

variable "sort_key" {
    type = string
    description = "The sort key of the table. It is used to sort the items in the table."
    default = null
}

variable "sort_key_type" {
    type = string
    description = "The data type of the sort key."
    default = null
}


