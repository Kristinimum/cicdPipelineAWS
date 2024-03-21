variable "oac_name" {
  type    = string
  default = "oac-hcnorth-cloudfront"
}

variable "cloudfront_location_restrictions" {
  default = ["US", "CA"]
}

variable "dev_website_bucketID" {}

variable "bucket_domain" {}

variable "prod_website_bucketID" {}

variable "bucket_domain_prod" {}