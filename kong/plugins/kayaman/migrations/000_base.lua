return {
  postgres = {
    up = [[
      CREATE TABLE IF NOT EXISTS "kayaman" (
        "id"                    UUID          PRIMARY KEY,
        "default_upstream"      TEXT,
        "country"               TEXT,
        "alternate_upstream"    TEXT,
        "key"                   TEXT          UNIQUE
      );
    ]],
  },

  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS kayaman(
        id                   uuid PRIMARY KEY,
        default_upstream     text,
        country              text,
        alternate_upstream   text,
        key                  text
      );
    ]],
  },
}
