variable "tag" {
    description = "The tag to apply to AWS resources"
    type        = string
}

variable "env" {
    description = "The environment"
    type        = string
}

variable "periodic_table_s3_bucket" {
    description = "The id of the periodic table s3 import bucket"
    type        = string
}