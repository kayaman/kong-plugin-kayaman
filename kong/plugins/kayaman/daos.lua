local typedefs = require "kong.db.schema.typedefs"

local SCHEMA = {
  table = "kayaman",
  primary_key = { "id" },
  endpoint_key = "key",
  cache_key = { "key" },
  fields = {
    { id = { type = typedefs.uuid }, },
    { country = { type = "string", required = true, unique = true }, },
    { upstream_name = { type = "string", required = true }, },
    { key = { type = "string", required = false, unique = true, auto = true }, },
  },
}

return { kayaman = SCHEMA }