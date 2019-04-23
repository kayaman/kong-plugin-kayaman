local BasePlugin = require "kong.plugins.base_plugin"
local Kayaman = BasePlugin:extend()

function Kayaman:new()
  Kayaman.super.new(self, "kayaman")
end

function Kayaman:access(config)
  Kayaman.super.access(self)

  if kong.request.get_header("x_country") == config.country then
    local ok, err = kong.service.set_upstream(config.alternate_upstream)
    kong.response.set_header("X-Kayaman-Proxied", "yes")
    if not ok then
      kong.log.err(err)
      return
    end
  else
    kong.service.set_upstream(config.default_upstream)
    kong.response.set_header("X-Kayaman-Proxied", "no")
  end
end

return Kayaman
