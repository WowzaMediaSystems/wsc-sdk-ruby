require 'request_interceptor'
require "unit/api_simulators/api_simulator"

class UllStreamTargetSimulator < ApiSimulator

  def plural_wrapper
    :stream_targets_ull
  end

  def singular_wrapper
    :stream_target_ull
  end

  def default_model
    {
      name:                       "ULL Stream Target",
      type:                       "ull",
      source_delivery_method:     WscSdk::Enums::DeliveryMethod::PUSH,
      stream_name:                "0I0q1bjZhRzZtfSdv4TpCnlmwQT16239",
      enabled:                    true,
      enable_hls:                 false,
      state:                      "stopped",
      connection_code:            "abcd1234",
      connection_code_expires_at: "2019-01-01 12:00:00",
      playback_urls:              {
        ws: [
          "ws://edge.cdn.wowza.com/live/_definst_/0I0q1bjZhRzZtfSdv4TpCnlmwQT16239/stream.ws",
          "wss://edge.cdn.wowza.com/live/_definst_/0I0q1bjZhRzZtfSdv4TpCnlmwQT16239/stream.ws"
        ],
        wowz: [],
        hls: []
      },
      primary_url:                "rtmp://origin.cdn.wowza.com:1935/live/0I0q1bjZhRzZtfSdv4TpCnlmwQT16239",
      created_at:                 "2019-01-01 12:00:00",
      updated_at:                 "2019-01-01 12:00:00"
    }
  end

  def build_models
    # NOTE: !!! This is not a good example of how to use templates.  This is an
    # abuse of templates, to keep the code more DRY, and generate expectations
    # for the tests.
    #
    {
      uid1: build_model(WscSdk::Templates::UllStreamTarget.pull("Ull Pull Stream Target 1", "http://primary_url.com")),
      uid2: build_model(WscSdk::Templates::UllStreamTarget.pull("Ull Pull Stream Target 2", "http://primary_url.com")),
      uid3: build_model(WscSdk::Templates::UllStreamTarget.push("Ull Push Stream Target 1")),
      uid4: build_model(WscSdk::Templates::UllStreamTarget.push("Ull Push Stream Target 2"))
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3\/stream_targets\/ull/ do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/stream_targets\/ull\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end


      # Intercept POST /api/v1.3/transcoders requests
      post /\/api\/v1\.3\/stream_targets\/ull/ do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/stream_targets\/ull\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end


      delete /\/api\/v1\.3\/stream_targets\/ull\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end
    end
  end
end
