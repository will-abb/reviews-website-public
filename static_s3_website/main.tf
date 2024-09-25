variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 Bucket"
  type        = string
  default     = "trendingtechdevices.com"
}

variable "index_path" {
  description = "Path to your index.html file"
  type        = string
  # this below I changed for the pipelie no validate, use full path if needed locally
  default = "../site_code/final_code/index.html"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone in Route53"
  type        = string
  default     = "Z071426418GLVEH321Y7I"
}

variable "hosted_zone_name" {
  description = "The name of the hosted zone in Route53"
  type        = string
  default     = "trendingtechdevices.com"
}

provider "aws" {
  region = var.aws_region
}

// S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

// S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "bucket_website" {
  bucket = aws_s3_bucket.bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

// CloudFront Origin Access Identity
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for S3 bucket"
}

// IAM Policy Document for CloudFront
data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid       = "Grant CloudFront OAI access to S3 bucket"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/*"]

    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.oai.s3_canonical_user_id]
    }
  }
}

// S3 Bucket Policy
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

// S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket                  = aws_s3_bucket.bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// S3 Error Object
resource "aws_s3_object" "error_object" {
  bucket = aws_s3_bucket.bucket.id
  # this below I changed for the pipelie no validate, use full path if needed locally
  source = "../site_code/final_code/error.html"
  key    = "error.html"
  # this below I changed for the pipelie no validate, use full path if needed locally
  etag         = filemd5("../site_code/final_code/error.html")
  content_type = "text/html"
}

// S3 Index Object
resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.bucket.id
  source       = var.index_path
  key          = "index.html"
  etag         = filemd5(var.index_path)
  content_type = "text/html"
}

// ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "trendingtechdevices.com"
  validation_method = "DNS"

  subject_alternative_names = ["*.trendingtechdevices.com"]

  tags = {
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// CloudFront Distribution
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = var.bucket_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["${var.hosted_zone_name}", "www.${var.hosted_zone_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.bucket_name

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

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

// Route53 Record for www subdomain
resource "aws_route53_record" "www_domain" {
  zone_id = var.hosted_zone_id
  name    = "www.${var.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.s3_distribution
  ]
}

// Route53 Record for the root domain
resource "aws_route53_record" "cloudfront_domain" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.s3_distribution,
  ]
}
