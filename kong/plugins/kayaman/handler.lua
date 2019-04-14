local BasePlugin = require "kong.plugins.base_plugin"
local Kayaman = BasePlugin:extend()

function Kayaman:new()
  Kayaman.super.new(self, "kayaman")
end

function Kayaman:access(plugin_conf)
  Kayaman.super.access(self)

  if kong.request.get_header("x_country") == "Italy" then
    local ok, err = kong.service.set_upstream("italy_cluster")
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
