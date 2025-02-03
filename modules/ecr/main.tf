resource "aws_ecr_repository" "periodic_table_repo" {
  name = "periodic-table-api-${var.env}"
  tags = {
    env = "${var.tag}"
  }
}