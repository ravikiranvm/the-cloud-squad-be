provider "aws" {
    region = "ap-south-1"
}

# S3 bucket to store state files for this application
resource "aws_s3_bucket" "terraform-state" {
    bucket = "terraform-state-for-p5"

    lifecycle {
        prevent_destroy = true
    }
} 

# Enable objec versioning on this bucket
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform-state.id

    versioning_configuration {
        status = "Enabled"
    }
}

# Explicity block public access to this bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
    bucket = aws_s3_bucket.terraform-state.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

# server side encryption for bucket objects
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
    bucket = aws_s3_bucket.terraform-state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Configure remote backend to store terraform state files for this application
terraform {
    backend "s3" {
        bucket = "terraform-state-for-p5"
        key = "global/s3/terraform.tfstate"
        region = "ap-south-1"
        encrypt = true
        use_lockfile = true
    }
}
