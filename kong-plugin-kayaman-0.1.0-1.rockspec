package = "kong-plugin-kayaman"
version = "0.1.0-1"
local pluginName = package:match("^kong%-plugin%-(.+)$")

supported_platforms = {"linux", "macosx"}

source = {
  url = "http://github.com/kayaman/kong-plugin-kayaman.git",
  tag = "0.1.0"
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
  }
}
