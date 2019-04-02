require 'request_interceptor'
require 'unit/api_simulators/api_simulator'

class OutputSimulator < ApiSimulator

  def plural_wrapper
    :outputs
  end

  def singular_wrapper
    :output
  end

  def default_model
    {
      name:       "Output Name is Generated",
      created_at: "2019-01-01 12:00:00",
      updated_at: "2019-01-01 12:00:00"
    }
  end

  def build_models
    {
      uid1: build_model(WscSdk::Templates::Output.hd),
      uid2: build_model(WscSdk::Templates::Output.sd_wide),
      uid3: build_model(WscSdk::Templates::Output.low_res_large),
      uid4: build_model(WscSdk::Templates::Output.low_res_medium),
      uid5: build_model(WscSdk::Templates::Output.low_res_small)
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs/ do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end

      # Intercept POST /api/v1.3/transcoders requests
      post /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs/ do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end


      delete /\/api\/v1\.3\/transcoders\/uid[0-9]+\/outputs\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end
    end
  end
end
