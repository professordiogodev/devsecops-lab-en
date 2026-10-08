# Demo Shop infrastructure (VULNERABLE ON PURPOSE - for the lab only)

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "invoices" {
  bucket = "demo-shop-invoices"
}

resource "aws_s3_bucket_acl" "invoices" {
  bucket = aws_s3_bucket.invoices.id
  acl    = "public-read"
}

resource "aws_security_group" "api" {
  name        = "shop-api"
  description = "API access"

  ingress {
    description = "SSH for debugging"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "orders" {
  identifier          = "shop-orders"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "admin"
  password            = "SuperSecret123!"
  publicly_accessible = true
  storage_encrypted   = false
  skip_final_snapshot = true
}
