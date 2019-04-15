local SCHEMA = {
  primary_key = {"id"},
  table = "kayaman",
  fields = {
    id = { type = "id", dao_insert_value = true },
    default_upstream = { type = "string", required = false },
    
    country = {
        name = { type = "string", required = false },
        upstream = { type = "string", required = false },
    },

    key = { type = "string", required = false, unique = true },
  }
}

return { kayaman = SCHEMA } 