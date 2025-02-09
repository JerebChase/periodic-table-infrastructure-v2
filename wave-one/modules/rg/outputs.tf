output "resource_query_json" {
  value = jsonencode({
    Type = "TAG_FILTERS_1_0",
    Query = {
      TagFilters = [
        {
          Key = "env",
          Values = [var.tag]
        }
      ]
    }
  })
}