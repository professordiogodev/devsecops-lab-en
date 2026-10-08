# Demo Shop infrastructure (fixed version)

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "invoices" {
  bucket = "demo-shop-invoices"
}

resource "aws_s3_bucket_public_access_block" "invoices" {
  bucket                  = aws_s3_bucket.invoices.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "invoices" {
  description         = "Invoices key"
  enable_key_rotation = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "invoices" {
  bucket = aws_s3_bucket.invoices.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.invoices.arn
    }
  }
}

resource "aws_security_group" "api" {
  name        = "shop-api"
  description = "API access"

  # No SSH: admin access through AWS SSM Session Manager (identity + audit trail)

  ingress {
    description = "API via internal load balancer"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_db_instance" "orders" {
  identifier                          = "shop-orders"
  engine                              = "postgres"
  instance_class                      = "db.t3.micro"
  allocated_storage                   = 20
  username                            = "shop_app"
  manage_master_user_password         = true # password managed and rotated by Secrets Manager
  iam_database_authentication_enabled = true
  publicly_accessible                 = false
  storage_encrypted                   = true
  skip_final_snapshot                 = true
}
