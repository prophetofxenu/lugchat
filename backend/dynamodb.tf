resource "aws_dynamodb_table" "lugchat" {
  name = "LUGChat"
  billing_mode = "PROVISIONED"
  read_capacity = 2
  write_capacity = 1
  hash_key = "Chatroom"
  range_key = "Timestamp"

  ttl {
    enabled = true
    attribute_name = "ExpiresOn"
  }

  attribute {
    name = "Chatroom"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }

}

