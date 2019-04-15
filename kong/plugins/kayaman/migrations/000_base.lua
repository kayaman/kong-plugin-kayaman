return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS "kayaman" (
        "id"                    UUID          PRIMARY KEY,
        "default_upstream"      TEXT,
        "name"                  TEXT,
        "upstream"              TEXT,
        "key"                   TEXT          UNIQUE
      );
    ]],
  },

  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS kayaman(
        id                   uuid PRIMARY KEY,
        default_upstream     text,
        name                 text,
        upstream             text,
        key                  text
      );
    ]],
  },
}
