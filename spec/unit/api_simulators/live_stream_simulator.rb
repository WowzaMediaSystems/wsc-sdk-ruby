require 'request_interceptor'
require 'unit/api_simulators/api_simulator'

class LiveStreamSimulator < ApiSimulator

  def plural_wrapper
    :live_streams
  end

  def singular_wrapper
    :live_stream
  end

  def default_model
    {
      name:                             "Live Stream",

      stream_source_id:                 "abcd1234",
      connection_code:                  "abcd1234",
      connection_code_expires_at:       "2019-01-01 12:00:00",

      delivery_protocols:               ["rtmp","rtsp","wowz","hls"],
      source_connection_information: {
        primary_server:"rtmp://p.ep793031.i.akamaientrypoint.net/EntryPoint",
        backup_server:"rtmp://b.ep793031.i.akamaientrypoint.net/EntryPoint",
        host_port:1935,
        stream_name:"ee3c4ae9@793031",
        username:"319499",
        password:"5720456474"
      },
      player_id:                        "abcd1234",
      player_type:                      "original_html5",
      player_responsive:                false,
      player_width:                     640,
      player_countdown:                 false,
      player_embed_code:                "in_progress",
      player_hls_playback_url:          "https://wowzaqainjest9-i.akamaihd.net/hls/live/747325/cb1ba31f/playlist.m3u8",
      hosted_page:                      true,
      hosted_page_title:                "My Live Stream",
      hosted_page_url:                  "in_progress",
      hosted_page_sharing_icons:        true,
      stream_targets: [
        {id:"rb3w4ykk"}
      ],
      direct_playback_urls: {
        hls:[
          { name:"default",     url:"https://727569-qa.entrypoint.cloud.wowza.com/app-83b9/ngrp:07fc2302_all/playlist.m3u8" }
        ],
        rtmp:[
          { name:"source",      url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302"},
          { name:"passthrough", output_id:"qdbhk1v0", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream1"},
          { name:"1280x720",    output_id:"rhrxz3yb", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream2"},
          { name:"854x480",     output_id:"n5fkg10y", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream3"},
          { name:"640x360",     output_id:"vgs2vbfv", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream4"},
          { name:"512x288",     output_id:"zgw0hsww", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream5"},
          { name:"320x180",     output_id:"wgp8qpcj", url:"rtmp://727569-qa.entrypoint.cloud.wowza.com/app-83b9/07fc2302_stream6"}
        ],
        rtsp:[
          { name:"source", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302"}, { name:"passthrough", output_id:"qdbhk1v0", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream1"},
          { name:"1280x720",    output_id:"rhrxz3yb", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream2"},
          { name:"854x480",     output_id:"n5fkg10y", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream3"},
          { name:"640x360",     output_id:"vgs2vbfv", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream4"},
          { name:"512x288",     output_id:"zgw0hsww", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream5"},
          { name:"320x180",     output_id:"wgp8qpcj", url:"rtsp://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream6"}
        ],
        wowz:[
          { name:"source",url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302"},
          { name:"passthrough", output_id:"qdbhk1v0", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream1"},
          { name:"1280x720",    output_id:"rhrxz3yb", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream2"},
          { name:"854x480",     output_id:"n5fkg10y", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream3"},
          { name:"640x360",     output_id:"vgs2vbfv", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream4"},
          { name:"512x288",     output_id:"zgw0hsww", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream5"},
          { name:"320x180",     output_id:"wgp8qpcj", url:"wowz://727569-qa.entrypoint.cloud.wowza.com:1935/app-83b9/07fc2302_stream6"}
        ]
      },

      created_at:                       "2019-01-01 12:00:00",
      updated_at:                       "2019-01-01 12:00:00"
    }
  end

  def build_models
    test_file_path        = File.expand_path(File.join(File.dirname(__FILE__), "../files"))
    test_image_file_path  = File.join(test_file_path, "images", "logo.png")

    @state_transitions = {
      uid1:   { initial: :stopped, transition: :starting,   final: :started, delay: 1.25,   timer: nil },
      uid2:   { initial: :started, transition: :stopping,   final: :stopped, delay: 1.25,   timer: nil },
      uid3:   { initial: :started, transition: :resetting,  final: :started, delay: 1.25,   timer: nil },
      uid4:   { initial: :started, transition: :invalid,    final: :invalid, delay: 1.25,   timer: nil },
      uid5:   { initial: :stopped, transition: :starting,   final: :started, delay: 15,     timer: nil },
      uid6:   { initial: :started, transition: :stopping,   final: :stopped, delay: 15,     timer: nil },
      uid7:   { initial: :started, transition: :resetting,  final: :started, delay: 15,     timer: nil }
    }

    # Universal settings
    width = 1920
    height = 1080

    # NOTE: !!! This is not a good example of how to use templates.  This is an
    # abuse of templates, to keep the code more DRY, and generate expectations
    # for the tests.
    #
    {
      uid1: build_model(WscSdk::Templates::LiveStream.wse_single_bitrate("WSE Live Stream 1",  width, height)),
      uid2: build_model(WscSdk::Templates::LiveStream.wse_multi_bitrate("WSE Live Stream 2",  width, height)),
      uid3: build_model(WscSdk::Templates::LiveStream.gocoder("GoCoder Live Stream 1",  width, height)),
      uid4: build_model(WscSdk::Templates::LiveStream.ip_camera("IP Camera Live Stream 1",  width, height, "rtsp://source_url.com")),
      uid5: build_model(WscSdk::Templates::LiveStream.rtmp_push("RTMP Push Live Stream 1",  width, height)),
      uid6: build_model(WscSdk::Templates::LiveStream.rtmp_pull("RTMP Pull Live Stream 1",  width, height, "rtsp://source_url.com")),
      uid7: build_model(WscSdk::Templates::LiveStream.rtsp_push("RTSP Push Live Stream 1",  width, height)),
      uid8: build_model(WscSdk::Templates::LiveStream.rtsp_pull("RTSP Pull Live Stream 1",  width, height, "rtsp://source_url.com"))
    }
  end

  def new_rtmp_pull_live_stream
    width = 1920
    height = 1080
    WscSdk::Templates::LiveStream.rtmp_pull("RTMP Pull Live Stream 1",  width, height, "rtsp://source_url.com")
  end

  def states
    @states ||= {
      stopped: {
        live_stream: {
          ip_address: nil,
          state: "stopped",
          uptime_id: nil
        }
      },

      starting: {
        live_stream: {
          ip_address: nil,
          state: "starting",
          uptime_id: nil
        }
      },
      started: {
        live_stream: {
          ip_address: "127.0.0.1",
          state: "started",
          uptime_id: "uptimeuid1"
        }
      },
      stopping: {
        live_stream: {
          ip_address: nil,
          state: "stopping",
          uptime_id: nil
        }
      },
      resetting: {
        live_stream: {
          ip_address: nil,
          state: "resetting",
          uptime_id: nil
        }
      },
      invalid: {
        meta: {
          status: 422,
          code: "ERR-422-InvalidStateChange",
          title: "Invalid State Change Error",
          message: "The request couldn't be processed. Stopping is not allowed! Transcoder is in stopped state.",
          description: ""
        }
      }
    }
  end

  def thumbnail_url
    {
      live_stream: {
        thumbnail_url: "http\:\/\/thumbnail_url\.live_streams\.cloud\.wowza\.com\/"
      }
    }
  end

  def stats
    {
      live_stream: {
        audio_codec: { value: 'mp3', status: "normal", text: "", unit: "" },
        bits_in_rate: { value: 1000.0, status: "normal", text: "", unit: "bps" },
        bits_out_rate: { value: 1000.0, status: "normal", text: "", unit: "bps" },
        bytes_in_rate: { value: 1.0, status: "normal", text: "", unit: "Bps" },
        bytes_out_rate: { value: 1.0, status: "normal", text: "", unit: "Bps" },
        configured_bytes_out_rate: { value: 1, status: "normal", text: "", unit: "Kbps" },
        connected: { value: true, status: "normal", text: "", unit: "" },
        cpu: { value: 20, status: "normal", text: "", unit: "%" },
        frame_size: { value: "1920x1080", status: "normal", text: "", unit: "" },
        frame_rate: { value: 60, status: "normal", text: "", unit: "FPS" },
        gpu_decoder_usage: { value: nil, status: "normal", text: "", unit: "" },
        gpu_driver_version: { value: "not_installed", status: "normal", text: "", unit: "" },
        gpu_encoder_usage: { value: nil, status: "normal", text: "", unit: "" },
        gpu_memory_usage: { value: nil, status: "normal", text: "", unit: "" },
        gpu_usage: { value: nil, status: "normal", text: "", unit: "" },
        height: { value: 1080, status: "normal", text: "", unit: "px" },
        keyframe_interval: { value: 25, status: "normal", text: "", unit: "GOP" },
        unique_views: { value: 1000, status: "normal", text: "", unit: "" },
        video_codec: { value: 'mp4', status: "normal", text: "", unit: "" },
        width: { value: 1920, status: "normal", text: "", unit: "px" }
      }
    }
  end

  def connection_code
    {
      live_stream: {
        connection_code: 'connectioncode'
      }
    }
  end

  def enable_all_stream_targets
    {
      live_stream: {
        stream_targets: {
          state: "enabled"
        }
      }
    }
  end

  def disable_all_stream_targets
    {
      live_stream: {
        stream_targets: {
          state: "disabled"
        }
      }
    }
  end

  # Manage state transition expectations for each test live_stream.
  #
  def state_transitions= transitions
    @state_transitions = transitions
  end

  def state_transitions
    @state_transitions || {}
  end

  def set_transition_timer(uid, time)
    transitions                     = state_transitions
    transitions[uid.to_sym][:timer] = time
    state_transitions               = transitions
  end

  def reset_transitions
    state_transitions.each do |uid, transition|
      self.reset_transition(uid)
    end
  end

  def reset_transition(uid)
    set_transition_timer(uid, nil)
  end

  def app
    _self = self
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/live_streams request
      get "/api/v1.3/live_streams" do
        _self.list.to_json
      end

      # Intercept /api/v1.3/live_streams/[uid] requests
      get /\/api\/v1\.3\/live_streams\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end

      # Intercept POST /api/v1.3/live_streams requests
      post "/api/v1.3/live_streams" do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/live_streams/[uid]
      put /\/api\/v1\.3\/live_streams\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      delete /\/api\/v1\.3\/live_streams\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end

      # Intercept /api/v1.3/live_streams/[uid]/[action] requests
      put /\/api\/v1\.3\/live_streams\/uid[0-9]+\/(start|stop|reset)/ do
        uid           = request.url.to_s.split("/")[-2].to_sym
        current_state = _self.state_transitions[uid][:transition]
        _self.set_transition_timer(uid, Time.now)

        content_type  "application/json"
        status        422 if current_state == :invalid
        _self.states[current_state].to_json
      end

      # Intercept /api/v1.3/live_streams/[uid]/state requests
      get /\/api\/v1\.3\/live_streams\/uid[0-9]+\/state/ do
        uid           = request.url.to_s.split("/")[-2].to_sym
        transition    = _self.state_transitions[uid]
        current_state = transition[:initial]

        unless transition[:timer].nil?
          elapsed     = Time.now - transition[:timer]
          if elapsed > transition[:delay]
            current_state       = transition[:final]
            _self.set_transition_timer(uid, nil)
          else
            current_state       = transition[:transition]
          end
        end

        content_type  "application/json"
        status        422 if current_state == :invalid
        _self.states[current_state].to_json
      end

      get /\/api\/v1\.3\/live_streams\/uid[0-9]+\/thumbnail\_url/ do
        uid                   = request.url.to_s.split("/")[-2].to_sym
        live_stream_thumbnail  = _self.thumbnail_url
        live_stream_thumbnail[:live_stream][:thumbnail_url] += "#{uid}"

        content_type "application/json"
        live_stream_thumbnail.to_json
      end

      get /\/api\/v1\.3\/live_streams\/uid[0-9]+\/stats/ do
        content_type "application/json"
        _self.stats.to_json
      end

      put /\/api\/v1\.3\/live_streams\/uid[0-9]+\/regenerate\_connection\_code/ do
        uid              = request.url.to_s.split("/")[-2].to_sym
        connection_code  = _self.connection_code
        connection_code[:live_stream][:connection_code] = "#{uid}"

        content_type "application/json"
        connection_code.to_json
      end

    end
  end
end
