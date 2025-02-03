resource "aws_dynamodb_table" "periodic_table_db" {
  name           = "periodic-table-${var.env}"
  billing_mode   = "PROVISIONED"
  hash_key       = "AtomicNumber"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "AtomicNumber"
    type = "N"
  }
  
  import_table {
    input_format = "CSV"
    s3_bucket_source {
      bucket = var.periodic_table_s3_bucket
      key_prefix = "periodic-table-import.csv"
    }
  }
  
  tags = {
    env = "${var.tag}"
  }
}