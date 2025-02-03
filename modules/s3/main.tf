resource "aws_s3_bucket" "periodic_table_bucket" {
  bucket        = "periodic-table-${var.env}"
  force_destroy = true
  
  tags = {
    env = "${var.tag}"
  }
}

resource "aws_s3_bucket_ownership_controls" "periodic_table_bucket_ownership" {
  bucket = aws_s3_bucket.periodic_table_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "periodic_table_bucket_public_access" {
  bucket = aws_s3_bucket.periodic_table_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "periodic_table_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.periodic_table_bucket_ownership,
    aws_s3_bucket_public_access_block.periodic_table_bucket_public_access,
  ]

  bucket = aws_s3_bucket.periodic_table_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "periodic_table_bucket_website_config" {
  bucket = aws_s3_bucket.periodic_table_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "periodic_table_object" {
  bucket = aws_s3_bucket.periodic_table_bucket.bucket
  key    = "periodic-table-import.csv"
  source = "periodic-table-import.csv"

  tags = {
    env = "${var.tag}"
  }
}