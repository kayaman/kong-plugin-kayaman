return {
  no_consumer = true,
  fields = {
    default_upstream = { type = "string", required = false, default = "europe_cluster" },
    country = { type = "string", required = false, default = "Italy" },
    alternate_upstream = { type = "string", required = false, default = "italy_cluster" },
  }
}