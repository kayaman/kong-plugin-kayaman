return {
  no_consumer = true,
  fields = {
    default_upstream = { type = "string", required = false, default = "europe_cluster" },
    country = {
      type = "table",
      schema = {
        fields = {
          name = { type = "string", required = false },
          upstream = { type = "string", required = false },
        }
      }
    }
  }
}