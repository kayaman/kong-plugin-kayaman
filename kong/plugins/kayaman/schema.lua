return {
  name = "kayaman",
  no_consumer = true,
  fields = {
    config = {
      type = "record",
      fields = {
        country = { type = "string", required = true, default = "Italy" },
        upstream_name = { type = "string", required = true, default = "italy_cluster" },
      }
    }
  }
}