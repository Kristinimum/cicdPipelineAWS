output "dev_website_bucketID" {
  value = aws_s3_bucket.dev_website_bucket.id
}

output "prod_website_bucketID" {
  value = aws_s3_bucket.prod_website_bucket.id
}

output "artifact_bucketID" {
  value = aws_s3_bucket.artifact_bucket.id
}

output "web_url" {
  description = "The website endpoint for the s3 bucket"
  value       = aws_s3_bucket_website_configuration.s3_bucket.website_endpoint
}

output "web_url_prod" {
  description = "The website endpoint for the s3 bucket"
  value       = aws_s3_bucket_website_configuration.s3_bucket_prod.website_endpoint
}

output "bucket_domain" {
  value = aws_s3_bucket.dev_website_bucket.bucket_regional_domain_name
}

output "bucket_domain_prod" {
  value = aws_s3_bucket.prod_website_bucket.bucket_regional_domain_name
}