resource "aws_s3_bucket" "lugchat" {
  bucket = "lugchat-frontend"
  acl = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

