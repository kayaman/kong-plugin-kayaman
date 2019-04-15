local SCHEMA = {
  primary_key = { "id" },
  cache_key = { "id" },
  table = "kayaman",
  fields = {
    id = { type = "id", dao_insert_value = true },
    country = { type = "string", required = true, unique = true },
    upstream_name = { type = "string", required = true },
  },
}

return { kayaman = SCHEMA }