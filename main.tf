variable "domain_name"{
    description = "The name of the domain for our website."
    default = "www.jdnguyen.tech"
}

provider "aws" {
  region = "us-east-1" 

  shared_config_files      = ["/app/.aws/config"]
  shared_credentials_files = ["/app/.aws/credentials"]
  profile                  = "default"
}

resource "aws_s3_bucket" "website" {
  bucket = var.domain_name
  force_destroy = true
}

# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.website.id
#   policy = data.aws_iam_policy_document.bucket_policy.json
# }

resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.example]
  bucket     = aws_s3_bucket.website.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "PublicReadGetObject",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
        }
      ]
    }
  )
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.website.arn,
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}

# data "aws_iam_policy_document" "bucket_policy" {
#   statement {
#     sid = "PublicReadGetObject"
#     effect = "Allow"
#     actions = [ "s3:GetObject" ]
#     principals {
#       type = "*"
#       identifiers = [ "*" ]
#     }
#     resources = [ "arn:aws:s3:::$(var.domain_name)" ]
#   }
# }

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "website_bucket_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
  }
# docker-compose run --rm terraform output
# website_bucket_url = "explorecalifornia.org.s3-website-us-east-1.amazonaws.com"
# give us the output URL

# iterative delete
# for object in $(aws s3 ls s3://explorecalifornia.org/ --recursive | awk '{print $4}'); do
#   aws s3 rm s3://explorecalifornia.org/$object