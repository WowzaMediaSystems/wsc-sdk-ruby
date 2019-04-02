require 'request_interceptor'
require "unit/api_simulators/api_simulator"

class OutputStreamTargetSimulator < ApiSimulator

  def plural_wrapper
    :output_stream_targets
  end

  def singular_wrapper
    :output_stream_target
  end

  def default_model
    {
      output_id:                    "uid1",
      stream_target_id:             "uid2",
      stream_target: {
        type: "wowza",
        id: "uid2",
        name: "Associated Stream Target"
      },
      use_stream_target_backup_url: false
    }
  end

  def build_models
    {
      uid1: build_model({}),
      uid2: build_model({})
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]\/output_stream_targets/ do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]\/output_stream_targets\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end

      # Intercept POST /api/v1.3/transcoders requests
      post /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]\/output_stream_targets/ do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]\/output_stream_targets\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end


      delete /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]\/output_stream_targets\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end
    end
  end
end
