output "state_file_bucket_arn" {
    value = aws_s3_bucket.terraform-state.arn
    description = "ARN of the bucket which stores the state files for this application"
}