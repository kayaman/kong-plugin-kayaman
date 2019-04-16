local helpers = require "spec.helpers"
local version = require("version").version or require("version")
local PLUGIN_NAME = "kayaman"
local KONG_VERSION = version(select(3, assert(helpers.kong_exec("version"))))

for _, strategy in helpers.each_strategy() do
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()
      local bp = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })
      -- Routes
      local route1 = bp.routes:insert({
        paths = { "/local" }
      })
      local route_br = bp.routes:insert({
        paths = { "/brazil" }
      })
      -- Plugins
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route1.id },
        config = {},
      }
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route_br.id },
        config = {
          country = "Brazil",
        },
      }

      assert(helpers.start_kong({
        database   = strategy,
        nginx_conf = "spec/fixtures/custom_nginx.template",
        plugins = "bundled," .. PLUGIN_NAME,
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
    end)

    describe("configuration", function()
      it("gets an indication that the request has been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/brazil",
          headers = {
            ["X-Country"] = "Brazil"
          }
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("yes", header_value)
      end)

      it("gets an indication that the request has not been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/brazil",
          headers = {}
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("no", header_value)
      end)

       it("gets an indication that the request has not been proxied from a header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/brazil",
          headers = {
            ["X-Country"] = "Italy"
          }
        })
        assert.response(r).has.status(200)
        local header_value = assert.response(r).has.header("X-Kayaman-Proxied")
        assert.equal("no", header_value)
      end)
    end)
  end)

end