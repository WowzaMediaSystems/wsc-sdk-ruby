require 'request_interceptor'
require 'unit/api_simulators/api_simulator'

class CustomStreamTargetSimulator < ApiSimulator

  def plural_wrapper
    :stream_targets_custom
  end

  def singular_wrapper
    :stream_target_custom
  end

  def default_model
    {
      type:                         "custom",
      stream_name:                  "test_stream_name",
      username:                     "username",
      password:                     "password",
      primary_url:                  "http://test_url/primary",
      backup_url:                   "http://test_url/primary",
      hds_playback_url:             "http://test_url/primary/hds",
      hls_playback_url:             "http://test_url/primary/hls",
      rtmp_playback_url:            "http://test_url/primary/rtmp",
      created_at:                   "2019-01-01 12:00:00",
      updated_at:                   "2019-01-01 12:00:00"
    }
  end

  def build_models
    # NOTE: !!! This is not a good example of how to use templates.  This is an
    # abuse of templates, to keep the code more DRY, and generate expectations
    # for the tests.
    #
    {
      uid1: build_model(WscSdk::Templates::CustomStreamTarget.akamai_hd("Custom Akamai HD Stream Target 1", "http://primary_url.com",  "stream1")),
      uid2: build_model(WscSdk::Templates::CustomStreamTarget.akamai_hls("Custom Akamai HLS Stream Target 2", "http://primary_url.com",  "stream2")),
      uid3: build_model(WscSdk::Templates::CustomStreamTarget.akamai_rtmp("Custom Akamai RTMP Stream Target 3", "http://primary_url.com",  "stream3")),
      uid4: build_model(WscSdk::Templates::CustomStreamTarget.limelight("Custom Limelight Stream Target 4", "http://primary_url.com",  "stream4")),
      uid5: build_model(WscSdk::Templates::CustomStreamTarget.rtmp("Custom RTMP Stream Target 1", "http://primary_url.com",  "stream5")),
      uid6: build_model(WscSdk::Templates::CustomStreamTarget.ustream("Custom UStream Stream Target 1", "http://primary_url.com",  "stream5"))
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3\/stream_targets\/custom/ do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/stream_targets\/custom\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end


      # Intercept POST /api/v1.3/transcoders requests
      post /\/api\/v1\.3\/stream_targets\/custom/ do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/stream_targets\/custom\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end


      delete /\/api\/v1\.3\/stream_targets\/custom\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end
    end
  end
end
