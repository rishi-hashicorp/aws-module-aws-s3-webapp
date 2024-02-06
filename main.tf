terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}


resource "aws_s3_bucket" "demo" {
  bucket = "${var.prefix}-${var.name}"
  acl    = "public-read"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.prefix}-${var.name}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"

  }
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  index_document {
    suffix = "index.html"
    content      = file("${path.module}/assets/index.html")
    content_type = "text/html"
    acl          = "public-read"
  }

  error_document {
    key = "error.html"
  }
}

