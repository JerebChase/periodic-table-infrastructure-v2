terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = var.periodic_table_bucket_endpoint
    origin_id                = "periodic-table-origin-${var.env}"
  
    custom_origin_config {
      origin_protocol_policy = "http-only" # S3 website only supports HTTP
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = "periodic-table-origin-${var.env}"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]

    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl        = 0
    default_ttl    = 3600  # 1 hour
    max_ttl        = 86400  # 1 day
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  aliases = [var.frontend_domain]

  price_class = "PriceClass_100"  # Cheapest price class (US, Canada, Europe)

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method = "sni-only"
  }

  tags = {
    env = "${var.tag}"
  }
}

resource "cloudflare_dns_record" "frontend_domain_record" {
  zone_id = var.zone_id
  name    = var.frontend_domain
  content = aws_cloudfront_distribution.website_distribution.domain_name
  type    = "CNAME"
  ttl     = 300
}