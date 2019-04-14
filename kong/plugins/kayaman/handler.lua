local BasePlugin = require "kong.plugins.base_plugin"
local Kayaman = BasePlugin:extend()

function Kayaman:new()
  Kayaman.super.new(self, "kayaman")
end

function Kayaman:access(plugin_conf)
  Kayaman.super.access(self)
  kong.log("hey hooooo kayaman!")

  if kong.request.get_header("x_country") == "Italy" then
    local ok, err = kong.service.set_upstream("italy_cluster")
    if not ok then
      kong.log.err(err)
      return
    end
  else
    kong.service.set_upstream("europe_cluster")
  end
  
  ngx.req.set_header("Hello-World", "this is on a request")

end

---[[ runs in the 'header_filter_by_lua_block'
function Kayaman:header_filter(plugin_conf)
  Kayaman.super.header_filter(self)

  kong.log(kong.request.get_headers())

  -- your custom code here, for example;
  ngx.header["Bye-World"] = "this is on the responseeeeeee"

end --]]

--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)
  plugin.super.body_filter(self)

  -- your custom code here

end --]]

--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)
  plugin.super.log(self)

  -- your custom code here

end --]]


-- set the plugin priority, which determines plugin execution order
Kayaman.PRIORITY = 1000

-- return our plugin object
return Kayaman
