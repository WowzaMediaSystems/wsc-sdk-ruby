####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/live_stream_simulator"

describe WscSdk::Models::LiveStream do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { LiveStreamSimulator.new }
  let(:app)       { simulator.app }
  before(:each)   { simulator.reset_transitions }

  #-----------------------------------------------------------------------------
  #  _____       _
  # |_   _|__ __| |_ ___
  #   | |/ -_|_-<  _(_-<
  #   |_|\___/__/\__/__/
  #
  #-----------------------------------------------------------------------------

  it "is configured as expected", unit_test: true do
    live_stream  = WscSdk.client.live_streams.build

    expect_attribute live_stream, :id,                                :string,    access: :read
    expect_attribute live_stream, :name,                              :string,    required: true
    expect_attribute live_stream, :transcoder_type,                   :string,    required: true,     validate: WscSdk::Enums::TranscoderType.values,     default: WscSdk::Enums::TranscoderType::TRANSCODED
    expect_attribute live_stream, :billing_mode,                      :string,    required: true,     validate: WscSdk::Enums::BillingMode.values,        default: WscSdk::Enums::BillingMode::PAY_AS_YOU_GO
    expect_attribute live_stream, :broadcast_location,                :string,    required: true,     validate: WscSdk::Enums::BroadcastLocation.values
    expect_attribute live_stream, :encoder,                           :string,    required: true,     validate: WscSdk::Enums::Encoder.values
    expect_attribute live_stream, :delivery_method,                   :string,    required: true,     validate: WscSdk::Enums::DeliveryMethod.values,     default: WscSdk::Enums::DeliveryMethod::PUSH
    expect_attribute live_stream, :delivery_type,                     :string,    required: :delivery_type_is_required?,  validate: WscSdk::Enums::DeliveryType.values, default: WscSdk::Enums::DeliveryType::SINGLE_BITRATE
    expect_attribute live_stream, :recording,                         :boolean
    expect_attribute live_stream, :closed_caption_type,               :string,                        validate: WscSdk::Enums::ClosedCaptionType.values
    expect_attribute live_stream, :target_delivery_protocol,          :string,                        default: WscSdk::Enums::TargetDeliveryProtocol::HLS_HTTPS
    expect_attribute live_stream, :use_stream_source,                 :boolean
    expect_attribute live_stream, :stream_source_id,                  :string,    access: :read
    expect_attribute live_stream, :aspect_ratio_width,                :integer,   required: true
    expect_attribute live_stream, :aspect_ratio_height,               :integer,   required: true
    expect_attribute live_stream, :source_url,                        :string,    access: :write,     required: :source_url_is_required?,                 default: :default_source_url
    expect_attribute live_stream, :connection_code,                   :string,    access: :read
    expect_attribute live_stream, :connection_code_expires_at,        :datetime,  access: :read
    expect_attribute live_stream, :disable_authentication,            :boolean,   access: :write
    expect_attribute live_stream, :username,                          :string,    access: :write
    expect_attribute live_stream, :password,                          :string,    access: :write
    expect_attribute live_stream, :delivery_protocols,                :array
    expect_attribute live_stream, :source_connection_information,     :hash,      access: :read
    expect_attribute live_stream, :direct_playback_urls,              :hash,      access: :read

    expect_attribute live_stream, :player_id,                         :string,    access: :read
    expect_attribute live_stream, :player_type,                       :string,                        validate: WscSdk::Enums::PlayerType.values
    expect_attribute live_stream, :player_responsive,                 :boolean
    expect_attribute live_stream, :player_width,                      :integer
    expect_attribute live_stream, :player_video_poster_image_url,     :string,    access: :read
    expect_attribute live_stream, :player_video_poster_image,         :string,    access: :write
    expect_attribute live_stream, :remove_player_video_poster_image,  :boolean,   access: :write
    expect_attribute live_stream, :player_countdown,                  :boolean
    expect_attribute live_stream, :player_countdown_at,               :datetime
    expect_attribute live_stream, :player_logo_image_url,             :string,    access: :read
    expect_attribute live_stream, :player_logo_image,                 :string,    access: :write
    expect_attribute live_stream, :remove_player_logo_image,          :boolean,   access: :write
    expect_attribute live_stream, :player_logo_position,              :string,                        validate: WscSdk::Enums::ImagePosition.values
    expect_attribute live_stream, :player_embed_code,                 :string,    access: :read
    expect_attribute live_stream, :player_hds_playback_url,           :string,    access: :read
    expect_attribute live_stream, :player_hls_playback_url,           :string,    access: :read

    expect_attribute live_stream, :hosted_page,                       :boolean,   access: :hosted_page_access
    expect_attribute live_stream, :hosted_page_title,                 :string
    expect_attribute live_stream, :hosted_page_description,           :string
    expect_attribute live_stream, :hosted_page_url,                   :string,    access: :read
    expect_attribute live_stream, :hosted_page_logo_image_url,        :string,    access: :read
    expect_attribute live_stream, :hosted_page_logo_image,            :string,    access: :write
    expect_attribute live_stream, :remove_hosted_page_logo_image,     :boolean,   access: :write
    expect_attribute live_stream, :hosted_page_sharing_icons,         :boolean


    expect_attribute live_stream, :created_at,                        :datetime,  access: :read
    expect_attribute live_stream, :updated_at,                        :datetime,  access: :read

  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      app.intercept do
        client          = WscSdk::Client.new
        live_stream_data = simulator.new_rtmp_pull_live_stream
        live_stream      = client.live_streams.build(live_stream_data)
        result          = nil

        expect(live_stream.id).to be_nil
        expect(live_stream.save.success?).to be_truthy
        expect(live_stream.id).not_to be_nil
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_streams = client.live_streams.list
        live_stream  = live_streams[live_streams.keys.last]

        live_stream.name = "This is an updated live_stream"

        expect(live_stream.save.success?).to be_truthy
        expect(live_stream.id).not_to be_nil
        expect(live_stream.name).to eq("This is an updated live_stream")
      end

    end

    it "can delete itself when its an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_streams = client.live_streams.list
        live_stream  = live_streams[live_streams.keys.last]

        expect(result = live_stream.delete.success?).to be_truthy
        expect(live_stream.id).to be_nil
      end

    end
  end

  context "Start Live Stream" do
    it "can start a live stream", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid1")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("stopped")

        live_stream_start = live_stream.start
        expect(live_stream_start.success?).to be_truthy
        expect(live_stream_start.state).to eq("starting")

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("starting")
      end
    end

    it "can start a live stream and wait for the started state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid1")

        expect(live_stream.success?).to be_truthy
        expect(live_stream.state.state).to eq("stopped")

        live_stream_state = live_stream.start(poll_interval: 1) do |wait_state, live_stream_state|
          if wait_state == :waiting
            expect(live_stream_state.state).to eq("starting")
          elsif wait_state == :complete
            expect(live_stream_state.state).to eq("started")
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can start a live stream and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid5")

        live_stream_state = live_stream.start(poll_interval: 1, timeout: 1) do |wait_state, live_stream_state|
          if wait_state == :timeout
            expect(live_stream_state.state).not_to eq("started")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can start a live stream and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy

        live_stream_state = live_stream.start do |wait_state, live_stream_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(live_stream_state.success?).to be_falsey
      end
    end
  end

  context "Stop Live Stream" do
    it "can stop a live stream", unit_test: true do
      app.intercept do
        # response = Net::HTTP.get(URI("http://live_streams_endpoint_test.wowza.com/api/v1.3/live_streams/"))
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid2")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("started")

        live_stream_stop = live_stream.stop
        expect(live_stream_stop.success?).to be_truthy
        expect(live_stream_stop.state).to eq("stopping")

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("stopping")
      end
    end

    it "can stop a live stream and wait for the stopped state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid2")

        expect(live_stream.success?).to be_truthy
        expect(live_stream.state.state).to eq("started")

        live_stream_state = live_stream.stop(poll_interval: 1) do |wait_state, live_stream_state|
          if wait_state == :waiting
            expect(live_stream_state.state).to eq("stopping")
          elsif wait_state == :complete
            expect(live_stream_state.state).to eq("stopped")
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can stop a live stream and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid6")

        live_stream_state = live_stream.stop(poll_interval: 1, timeout: 1) do |wait_state, live_stream_state|
          if wait_state == :timeout
            expect(live_stream_state.state).not_to eq("stopped")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can stop a live stream and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy

        live_stream_state = live_stream.stop do |wait_state, live_stream_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(live_stream_state.success?).to be_falsey
      end
    end
  end

  context "Reset Live Stream" do
    it "can reset a live stream", unit_test: true do
      app.intercept do
        # response = Net::HTTP.get(URI("http://live_streams_endpoint_test.wowza.com/api/v1.3/live_streams/"))
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid3")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("started")

        live_stream_reset = live_stream.reset
        expect(live_stream_reset.success?).to be_truthy
        expect(live_stream_reset.state).to eq("resetting")

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy
        expect(live_stream_state.state).to eq("resetting")
      end
    end

    it "can reset a live stream and wait for the started state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid3")

        expect(live_stream.success?).to be_truthy
        expect(live_stream.state.state).to eq("started")

        live_stream_state = live_stream.reset(poll_interval: 1) do |wait_state, live_stream_state|
          if wait_state == :waiting
            expect(live_stream_state.state).to eq("resetting")
          elsif wait_state == :complete
            expect(live_stream_state.state).to eq("started")
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can reset a live stream and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid7")

        live_stream_state = live_stream.reset(poll_interval: 1, timeout: 1) do |wait_state, live_stream_state|
          if wait_state == :timeout
            expect(live_stream_state.state).not_to eq("started")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(live_stream_state.success?).to be_truthy
      end
    end

    it "can reset a live stream and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")

        expect(live_stream.success?).to be_truthy

        live_stream_state = live_stream.state
        expect(live_stream_state.success?).to be_truthy

        live_stream_state = live_stream.reset do |wait_state, live_stream_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(live_stream_state.success?).to be_falsey
      end
    end

  end

  context "Other Transcoder Actions" do
    it "can request a thumbnail url", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")
        expect(live_stream.success?).to be_truthy

        thumbnail_url = live_stream.thumbnail_url
        expect(thumbnail_url.success?).to be_truthy
        expect(thumbnail_url.thumbnail_url).to eq("http://thumbnail_url.live_streams.cloud.wowza.com/uid4")
      end
    end

    it "can request stats", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")
        expect(live_stream.success?).to be_truthy

        stats = live_stream.stats
        expect(stats.success?).to be_truthy
      end
    end

    it "can regenerate its connection code", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        live_stream = client.live_streams.find("uid4")
        expect(live_stream.success?).to be_truthy

        connection_code = live_stream.regenerate_connection_code
        expect(connection_code.success?).to be_truthy
        expect(connection_code.connection_code).to eq("uid4")
      end
    end

  end
end
