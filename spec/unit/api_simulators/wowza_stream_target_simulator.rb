####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'request_interceptor'
require "unit/api_simulators/api_simulator"

class WowzaStreamTargetSimulator < ApiSimulator

  def plural_wrapper
    :stream_targets_wowza
  end

  def singular_wrapper
    :stream_target_wowza
  end

  def default_model
    {
      type:                         "wowza",
      stream_name:                  "test_stream_name",
      secure_ingest_query_param:    nil,
      username:                     "username",
      password:                     "password",
      primary_url:                  "http://test_url/primary",
      backup_url:                   "http://test_url/primary",
      hds_playback_url:             "http://test_url/primary/hds",
      hls_playback_url:             "http://test_url/primary/hls",
      rtmp_playback_url:            "http://test_url/primary/rtmp",
      connection_code:              "abcd1234",
      connection_code_expires_at:   "2019-01-01 12:00:00",
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
      uid1: build_model(WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("Wowza Akamai Cupertino Stream Target 1", false,  false)),
      uid2: build_model(WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("Wowza Akamai Cupertino Stream Target 2", true,   false)),
      uid3: build_model(WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("Wowza Akamai Cupertino Stream Target 3", false,  true)),
      uid4: build_model(WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("Wowza Akamai Cupertino Stream Target 4", true,   true)),
      uid5: build_model(WscSdk::Templates::WowzaStreamTarget.akamai("Wowza Akamai Stream Target 1", WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,))
    }
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3\/stream_targets\/wowza/ do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/stream_targets\/wowza\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end


      # Intercept POST /api/v1.3/transcoders requests
      post /\/api\/v1\.3\/stream_targets\/wowza/ do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/stream_targets\/wowza\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end


      delete /\/api\/v1\.3\/stream_targets\/wowza\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end
    end
  end
end
