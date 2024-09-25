terraform {
  backend "s3" {
    bucket = "will-websites-backend"
    key    = "reviews-website/s3/static_website/terraform.state"
    region = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
