require 'request_interceptor'
require "unit/api_simulators/api_simulator"

class StreamTargetSimulator < ApiSimulator

  def plural_wrapper
    :stream_targets
  end

  def singular_wrapper
    :stream_target
  end

  def default_model
    {
      name:       "Transcoder",
      type:       "wowza",
      created_at: "2019-01-01 12:00:00",
      updated_at: "2019-01-01 12:00:00"
    }
  end

  def build_models
    {
      uid1: build_model(name: "Wowza Stream Target 1", type: "wowza"),
      uid2: build_model(name: "Wowza Stream Target 2", type: "wowza"),
      uid3: build_model(name: "Custom Stream Target 1", type: "custom"),
      uid4: build_model(name: "Custom Stream Target 2", type: "custom"),
      uid5: build_model(name: "ULL Stream Target 1", type: "ull"),
      uid6: build_model(name: "ULL Stream Target 2", type: "ull"),
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get "/api/v1.3/stream_targets" do
        _self.list.to_json
      end
    end
  end
end
