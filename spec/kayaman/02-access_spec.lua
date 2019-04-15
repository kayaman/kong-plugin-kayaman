local helpers = require "spec.helpers"
local version = require("version").version or require("version")
local PLUGIN_NAME = "kayaman"
local KONG_VERSION = version(select(3, assert(helpers.kong_exec("version"))))


for _, strategy in helpers.each_strategy() do
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()
      local bp, route1

      if KONG_VERSION >= version("0.15.0") then
        local bp = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })
        local route1 = bp.routes:insert({
          paths = { "/local" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route = { id = route1.id },
          config = {},
        }

        local route2 = bp.routes:insert({
          paths = { "/local2" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route = { id = route2.id },
          config = { ["country"] = "Belgium" },
        }
      else
        local bp = helpers.get_db_utils(strategy)
        local route1 = bp.routes:insert({
          paths = { "/local" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route_id = route1.id,
          config = {},
        }

        local route2 = bp.routes:insert({
          paths = { "/local2" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route_id = route2.id,
          config = { country = "Belgium" },
        }
      end

      assert(helpers.start_kong({
        database   = strategy,
        nginx_conf = "spec/fixtures/custom_nginx.template",
        plugins = "bundled," .. PLUGIN_NAME,  -- since Kong CE 0.14
        custom_plugins = PLUGIN_NAME,         -- pre Kong CE 0.14
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)


    describe("request", function()
      it("gets an indication that the request has been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/local",
          headers = {
            ["X-Country"] = "Italy"
          }
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("yes", header_value)
      end)

      it("gets an indication that the request has not been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/local",
          headers = {}
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("no", header_value)
      end)
    
  
    it("gets an indication that the request has been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/local2",
          headers = {
            ["X-Country"] = "Belgium"
          }
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("yes", header_value)
      end)
    end)

    it("gets an indication that the request has not been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/local2",
          headers = {}
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("no", header_value)
      end)
    end)
  end)
end)
