local schema_def = require "kong.plugins.kayaman.schema"
local v = require("spec.helpers").validate_plugin_config_schema


describe("Plugin: kayaman (schema)", function()
  it("proper config validates", function()
    local config = { }
    local ok, _, err = v(config, schema_def)
    assert.truthy(ok)
    assert.is_nil(err)
  end)
end)