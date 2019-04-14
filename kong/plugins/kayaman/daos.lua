local typedefs = require "kong.db.schema.typedefs"

return {
  kayaman = {
    primary_key = { "id" },
    name = "kayaman",
    fields = {
      { id = typedefs.uuid },
      { country = { type = "string", required = true, unique = true }, },
      { upstream_name = { type = "string", required = true, unique = false }, },
    },
  },
}