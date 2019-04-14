return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS "kayaman" (
        "id"                    UUID          PRIMARY KEY,
        "country"               TEXT          UNIQUE,
        "upstream_name"         TEXT
      );
    ]],
  },

  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS kayaman(
        id                   uuid PRIMARY KEY,
        country              text,
        upstream_name        text
      );
    ]],
  },
}
