variable "tag" {
    description = "The tag to apply to AWS resources"
    type        = string
}

variable "env" {
    description = "The environment"
    type        = string
}

variable "periodic_table_db_arn" {
    description = "The arn of the periodic table db"
    type        = string
}