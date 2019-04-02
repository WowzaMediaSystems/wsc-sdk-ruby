####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'request_interceptor'
require "unit/api_simulators/api_simulator"

class TranscoderSimulator < ApiSimulator

  def plural_wrapper
    :transcoders
  end

  def singular_wrapper
    :transcoder
  end

  def default_model
    {
      name:       "Transcoder",
      created_at: "2019-01-01 12:00:00",
      updated_at: "2019-01-01 12:00:00"
    }
  end

  def new_pull_rtmp_transcoder(data={})
    WscSdk::Templates::Transcoder.rtmp_pull("New Pull Transcoder", 'rtmp://mydomain.net/live', data)
  end

  def new_push_rtsp_transcoder(data={})
    WscSdk::Templates::Transcoder.rtsp_push("New Push Transcoder", nil, data)
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

    # NOTE: !!! This is not a good example of how to use templates.  This is an
    # abuse of templates, to keep the code more DRY, and generate expectations
    # for the tests.
    #
    {
      uid1: build_model(WscSdk::Templates::Transcoder.rtmp_pull("Pull Transcoder 1",  'rtmp://mydomain.net/live')),
      uid2: build_model(WscSdk::Templates::Transcoder.rtmp_push("Push Transcoder 1",  nil,
        stream_extension: '.sdp',
        recording: true,
        closed_caption_type: 'cea',
        buffer_size: 5000,
        stream_smoother: false,
        low_latency: false,
        play_maximum_connections: 23,
        disable_authentication: false,
        username: 'user1',
        password: 'secret',
        delivery_protocols: ['rtmp','rtsp'],
        watermark: true,
        watermark_image: WscSdk::Client.file_to_base64(test_image_file_path),
        watermark_position: 'bottom-left',
        watermark_width: 100,
        watermark_height: 80,
        watermark_opacity: 20,
        description: "This is a push transcoder"
      )),
      uid3: build_model(WscSdk::Templates::Transcoder.rtmp_push("Push Transcoder 2", 'rtmp://mydomain.net/live')),
      uid4: build_model(WscSdk::Templates::Transcoder.rtmp_pull("Pull Transcoder 2", 'rtmp://mydomain.net/live')),
      uid5: build_model(WscSdk::Templates::Transcoder.rtmp_pull("Pull Transcoder 3", 'rtmp://mydomain.net/live')),
      uid6: build_model(WscSdk::Templates::Transcoder.rtmp_pull("Pull Transcoder 4", 'rtmp://mydomain.net/live')),
      uid7: build_model(WscSdk::Templates::Transcoder.rtmp_pull("Pull Transcoder 5", 'rtmp://mydomain.net/live'))
    }
  end


  def states
    @states ||= {
      stopped: {
        transcoder: {
          ip_address: nil,
          state: "stopped",
          uptime_id: nil
        }
      },

      starting: {
        transcoder: {
          ip_address: nil,
          state: "starting",
          uptime_id: nil
        }
      },
      started: {
        transcoder: {
          ip_address: "127.0.0.1",
          state: "started",
          uptime_id: "uptimeuid1"
        }
      },
      stopping: {
        transcoder: {
          ip_address: nil,
          state: "stopping",
          uptime_id: nil
        }
      },
      resetting: {
        transcoder: {
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
      transcoder: {
        thumbnail_url: "http://thumbnail_url.transcoders.cloud.wowza.com/"
      }
    }
  end

  def stats
    {
      transcoder: {
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
      transcoder: {
        connection_code: 'connectioncode'
      }
    }
  end

  def enable_all_stream_targets
    {
      transcoder: {
        stream_targets: {
          state: "enabled"
        }
      }
    }
  end

  def disable_all_stream_targets
    {
      transcoder: {
        stream_targets: {
          state: "disabled"
        }
      }
    }
  end

  # Manage state transition expectations for each test transcoder.
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

      # Intercept GET /api/v1.3/transcoders request
      get "/api/v1.3/transcoders" do
        _self.list.to_json
      end

      # Intercept /api/v1.3/transcoders/[uid] requests
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+/ do
        uid   = request.url.to_s.split("/").last.to_sym
        model = _self.find(uid)

        content_type "application/json"
        model.to_json
      end

      # Intercept POST /api/v1.3/transcoders requests
      post "/api/v1.3/transcoders" do
        model = _self.create(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      # Intercept PUT /api/v1.3/transcoders/[uid]
      put /\/api\/v1\.3\/transcoders\/uid[0-9]+/ do
        model = _self.update(JSON.parse(request.body.read))

        content_type  "application/json"
        model.to_json
      end

      delete /\/api\/v1\.3\/transcoders\/uid[0-9]+/ do
        uid = request.url.to_s.split("/").last.to_sym
        _self.delete(uid)

        content_type "application/json"
        status       203
        ""
      end

      # Intercept /api/v1.3/transcoders/[uid]/[action] requests
      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/(start|stop|reset)/ do
        uid           = request.url.to_s.split("/")[-2].to_sym
        current_state = _self.state_transitions[uid][:transition]
        _self.set_transition_timer(uid, Time.now)

        content_type  "application/json"
        status        422 if current_state == :invalid
        _self.states[current_state].to_json
      end

      # Intercept /api/v1.3/transcoders/[uid]/state requests
      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/state/ do
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

      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/thumbnail\_url/ do
        uid                   = request.url.to_s.split("/")[-2].to_sym
        transcoder_thumbnail  = _self.thumbnail_url
        transcoder_thumbnail[:transcoder][:thumbnail_url] += "#{uid}"

        content_type "application/json"
        transcoder_thumbnail.to_json
      end

      get /\/api\/v1\.3\/transcoders\/uid[0-9]+\/stats/ do
        content_type "application/json"
        _self.stats.to_json
      end

      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/regenerate\_connection\_code/ do
        uid              = request.url.to_s.split("/")[-2].to_sym
        connection_code  = _self.connection_code
        connection_code[:transcoder][:connection_code] = "#{uid}"

        content_type "application/json"
        connection_code.to_json
      end

      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/enable\_all\_stream\_targets/ do
        content_type "application/json"
        _self.enable_all_stream_targets.to_json
      end

      put /\/api\/v1\.3\/transcoders\/uid[0-9]+\/disable\_all\_stream\_targets/ do
        content_type "application/json"
        _self.disable_all_stream_targets.to_json
      end

    end
  end
end
