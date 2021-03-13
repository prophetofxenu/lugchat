resource "random_id" "bucket" {
  byte_length = 4
}

resource "aws_s3_bucket" "lugchat" {
  bucket = "lugchat-frontend-${random_id.bucket.hex}"
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

