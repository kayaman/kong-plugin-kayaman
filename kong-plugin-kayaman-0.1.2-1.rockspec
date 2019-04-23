package = "kong-plugin-kayaman"
version = "0.1.2-1"
local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}

source = {
  url = "http://github.com/kayaman/kong-plugin-kayaman.git",
  tag = "0.1.2"
}

description = {
  summary = "Proxy requests from specific routes to different upstreams given the presence of specific headers",
  homepage = "http://konghq.com",
  license = "Apache 2.0"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins.kayaman.handler"] = "kong/plugins/kayaman/handler.lua",
    ["kong.plugins.kayaman.schema"] = "kong/plugins/kayaman/schema.lua",
    ["kong.plugins.kayaman.daos"] = "kong/plugins/kayaman/daos.lua",
    ["kong.plugins.kayaman.migrations.init"] = "kong/plugins/kayaman/migrations/init.lua",
    ["kong.plugins.kayaman.migrations.000_base"] = "kong/plugins/kayaman/migrations/000_base.lua",
  }
}
