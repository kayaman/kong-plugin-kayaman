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
        --
        -- Kong version 0.15.0/1.0.0, new test helpers
        --
        local bp = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })

        local route1 = bp.routes:insert({
          paths = { "/local" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route = { id = route1.id },
          config = {},
        }
      else
        --
        -- Pre Kong version 0.15.0/1.0.0, older test helpers
        --
        local bp = helpers.get_db_utils(strategy)

        local route1 = bp.routes:insert({
          paths = { "/local" }
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route_id = route1.id,
          config = {},
        }
      end

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- set the config item to make sure our plugin gets loaded
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
      it("to be defined", function()
        local r = assert(client:send {
          method = "GET",
          path = "/local",
          headers = {
            x_country = "Italy"
          }
        })
        assert.response(r).has.status(200)
      end)
    end)



    describe("response", function()
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

  end)
end
