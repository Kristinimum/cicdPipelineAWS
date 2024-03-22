####################    Name origin ID    #####################

locals {
  s3_origin_id = "myS3Origin"
}


########    Create origin access control resource   ###########

resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = var.oac_name
  description                       = "S3 static website cloudfront policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


########   Create Cloudfront distribution resource for DEV   ##########

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = var.bucket_domain
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Origin S3 bucket:dev_website_bucketID, index.html"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.cloudfront_location_restrictions
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}



### Create Cloudfront distribution resource for PROD  #######

resource "aws_cloudfront_distribution" "s3_distribution_prod" {
  origin {
    domain_name              = var.bucket_domain_prod 
    origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Origin S3 bucket:dev_website_bucketID, index.html"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = var.cloudfront_location_restrictions
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}