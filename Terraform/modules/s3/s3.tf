#####################################################################################
##################   Create DEV s3 bucket to host static website    #################
#####################################################################################

resource "aws_s3_bucket" "dev_website_bucket" {
  bucket        = var.dev_website_bucket_name
  force_destroy = true

  tags = {
    Name = "WebsiteBucket"
  }
}


####  upload "index" & "error" html" files to the bucket from a local path  #####

resource "aws_s3_object" "upload_object" {
  for_each     = fileset("files/", "*")
  bucket       = aws_s3_bucket.dev_website_bucket.id
  key          = each.value
  source       = "files/${each.value}"
  etag         = filemd5("files/${each.value}")
  content_type = "text/html"
}


###################     Remove blocks to public access    ######################

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.dev_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#############     Configure the s3 bucket to host static website    ###########

resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.dev_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

###  Bucket policy to allow AWS Cloudfront service to GetObject from bucket ###

resource "aws_s3_bucket_policy" "website_policy" {
  bucket = aws_s3_bucket.dev_website_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : ["${aws_s3_bucket.dev_website_bucket.arn}/*"],
        "Action" : "s3:GetObject",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
      }
    ]
  })
}



#####################################################################################
#################   Create PROD s3 bucket to host static website    #################
#####################################################################################

resource "aws_s3_bucket" "prod_website_bucket" {
  bucket        = var.prod_website_bucket_name
  force_destroy = true

  tags = {
    Name = "WebsiteBucket"
  }
}


####  upload "index" & "error" html" files to the bucket from a local path  #####

resource "aws_s3_object" "upload_object_prod" {
  for_each     = fileset("files/", "*")
  bucket       = aws_s3_bucket.prod_website_bucket.id
  key          = each.value
  source       = "files/${each.value}"
  etag         = filemd5("files/${each.value}")
  content_type = "text/html"
}


###################     Remove blocks to public access    ######################

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block_prod" {
  bucket = aws_s3_bucket.prod_website_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#############     Configure the s3 bucket to host static website    ###########

resource "aws_s3_bucket_website_configuration" "s3_bucket_prod" {
  bucket = aws_s3_bucket.prod_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

###  Bucket policy to allow AWS Cloudfront service to GetObject from bucket ###

resource "aws_s3_bucket_policy" "website_policy_prod" {
  bucket = aws_s3_bucket.prod_website_bucket.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" :["${aws_s3_bucket.prod_website_bucket.arn}/*"],
        "Action" : "s3:GetObject",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
      }
    ]
  })
}






#####################################################################################
##############   Create ARTIFACT s3 bucket to host static website    ################
#####################################################################################

resource "aws_s3_bucket" "artifact_bucket" {
  bucket        = var.artifact_bucket_name
  force_destroy = true

  tags = {
    Name = "ArtifactBucket"
  }
}