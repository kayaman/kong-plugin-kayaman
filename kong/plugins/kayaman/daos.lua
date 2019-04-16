local SCHEMA = {
  primary_key = "id",
  table = "kayaman",
  fields = {
    id = { type = "id", dao_insert_value = true },
    default_upstream = { type = "string", required = false },
    country = { type = "string", required = false },
    alternate_upstream = { type = "string", required = false },
    key = { type = "string", required = false, unique = true },
  }
}

return { kayaman = SCHEMA } 