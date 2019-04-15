local BasePlugin = require "kong.plugins.base_plugin"
local Kayaman = BasePlugin:extend()

function Kayaman:new()
  Kayaman.super.new(self, "kayaman")
end

function Kayaman:access(config)
  Kayaman.super.access(self)

  kong.log.inspect(config.country)
  kong.log.inspect(config.default_upstream)
  kong.log.inspect(config.alternate_upstream)

  if kong.request.get_header("x_country") == config.country then
    local ok, err = kong.service.set_upstream(config.alternate_upstream)
    kong.response.set_header("X-Kayaman-Proxied", "yes")
    if not ok then
      kong.log.err(err)
      return
    end
  else
    kong.service.set_upstream("europe_cluster")
    kong.response.set_header("X-Kayaman-Proxied", "no")
  end
end

return Kayaman
