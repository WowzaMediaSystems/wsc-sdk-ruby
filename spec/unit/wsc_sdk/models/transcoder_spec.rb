####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"

describe WscSdk::Models::Transcoder do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { TranscoderSimulator.new }
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
    transcoder  = WscSdk.client.transcoders.build

    expect_attribute transcoder, :id,                      :string,    access: :read
    expect_attribute transcoder, :name,                    :string,    required: true
    expect_attribute transcoder, :transcoder_type,         :string,    required: true,     validate: WscSdk::Enums::TranscoderType.values,     default: WscSdk::Enums::TranscoderType::TRANSCODED
    expect_attribute transcoder, :billing_mode,            :string,    required: true,     validate: WscSdk::Enums::BillingMode.values,        default: WscSdk::Enums::BillingMode::PAY_AS_YOU_GO
    expect_attribute transcoder, :broadcast_location,      :string,    required: true,     validate: WscSdk::Enums::BroadcastLocation.values
    expect_attribute transcoder, :protocol,                :string,    required: true,     validate: WscSdk::Enums::Protocol.values
    expect_attribute transcoder, :delivery_method,         :string,    required: true,     validate: WscSdk::Enums::DeliveryMethod.values
    expect_attribute transcoder, :source_url,              :string,    required: :source_url_is_required?
    expect_attribute transcoder, :recording,               :boolean
    expect_attribute transcoder, :closed_caption_type,     :string,                        validate: WscSdk::Enums::ClosedCaptionType.values
    expect_attribute transcoder, :stream_extension,        :string
    expect_attribute transcoder, :stream_source_id,        :string
    expect_attribute transcoder, :delivery_protocols,      :array
    expect_attribute transcoder, :buffer_size,             :integer,                       validate: WscSdk::Enums::BufferSize.values
    expect_attribute transcoder, :low_latency,             :boolean
    expect_attribute transcoder, :stream_smoother,         :boolean
    expect_attribute transcoder, :idle_timeout,            :integer,                       validate: WscSdk::Enums::IdleTimeout.values
    expect_attribute transcoder, :play_maximum_connections,:integer
    expect_attribute transcoder, :disable_authentication,  :boolean
    expect_attribute transcoder, :username,                :string
    expect_attribute transcoder, :password,                :string
    expect_attribute transcoder, :description,             :string

    expect_attribute transcoder, :watermark,               :boolean,   default: false
    expect_attribute transcoder, :watermark_image,         :string
    expect_attribute transcoder, :watermark_position,      :string,                        validate: WscSdk::Enums::ImagePosition.values
    expect_attribute transcoder, :watermark_width,         :integer
    expect_attribute transcoder, :watermark_height,        :integer
    expect_attribute transcoder, :watermark_opacity,       :integer,                       validate: (0..100).to_a

    expect_attribute transcoder, :source_port,             :string,    access: :read
    expect_attribute transcoder, :domain_name,             :string,    access: :read
    expect_attribute transcoder, :application_name,        :string,    access: :read
    expect_attribute transcoder, :stream_name,             :string,    access: :read
    expect_attribute transcoder, :direct_playback_urls,    :hash,      access: :read
    expect_attribute transcoder, :created_at,              :datetime,  access: :read
    expect_attribute transcoder, :updated_at,              :datetime,  access: :read
  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      app.intercept do
        client          = WscSdk::Client.new
        transcoder_data = simulator.new_pull_rtmp_transcoder
        transcoder      = client.transcoders.build(transcoder_data)
        result          = nil

        expect(transcoder.id).to be_nil
        expect(transcoder.save.success?).to be_truthy
        expect(transcoder.id).not_to be_nil
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoders = client.transcoders.list
        transcoder  = transcoders[transcoders.keys.last]

        transcoder.name = "This is an updated transcoder"

        expect(transcoder.save.success?).to be_truthy
        expect(transcoder.id).not_to be_nil
        expect(transcoder.name).to eq("This is an updated transcoder")
      end

    end

    it "can delete itself when its an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoders = client.transcoders.list
        transcoder  = transcoders[transcoders.keys.last]

        expect(result = transcoder.delete.success?).to be_truthy
        expect(transcoder.id).to be_nil
      end

    end
  end

  context "Start Transcoder" do
    it "can start a transcoder", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid1")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("stopped")

        transcoder_start = transcoder.start
        expect(transcoder_start.success?).to be_truthy
        expect(transcoder_start.state).to eq("starting")

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("starting")
      end
    end

    it "can start a transcoder and wait for the started state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid1")

        expect(transcoder.success?).to be_truthy
        expect(transcoder.state.state).to eq("stopped")

        transcoder_state = transcoder.start(poll_interval: 1) do |wait_state, transcoder_state|
          if wait_state == :waiting
            expect(transcoder_state.state).to eq("starting")
          elsif wait_state == :complete
            expect(transcoder_state.state).to eq("started")
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can start a transcoder and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid5")

        transcoder_state = transcoder.start(poll_interval: 1, timeout: 1) do |wait_state, transcoder_state|
          if wait_state == :timeout
            expect(transcoder_state.state).not_to eq("started")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can start a transcoder and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy

        transcoder_state = transcoder.start do |wait_state, transcoder_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(transcoder_state.success?).to be_falsey
      end
    end
  end

  context "Stop Transcoder" do
    it "can stop a transcoder", unit_test: true do
      app.intercept do
        # response = Net::HTTP.get(URI("http://transcoders_endpoint_test.wowza.com/api/v1.3/transcoders/"))
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid2")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("started")

        transcoder_stop = transcoder.stop
        expect(transcoder_stop.success?).to be_truthy
        expect(transcoder_stop.state).to eq("stopping")

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("stopping")
      end
    end

    it "can stop a transcoder and wait for the stopped state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid2")

        expect(transcoder.success?).to be_truthy
        expect(transcoder.state.state).to eq("started")

        transcoder_state = transcoder.stop(poll_interval: 1) do |wait_state, transcoder_state|
          if wait_state == :waiting
            expect(transcoder_state.state).to eq("stopping")
          elsif wait_state == :complete
            expect(transcoder_state.state).to eq("stopped")
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can stop a transcoder and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid6")

        transcoder_state = transcoder.stop(poll_interval: 1, timeout: 1) do |wait_state, transcoder_state|
          if wait_state == :timeout
            expect(transcoder_state.state).not_to eq("stopped")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can stop a transcoder and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy

        transcoder_state = transcoder.stop do |wait_state, transcoder_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(transcoder_state.success?).to be_falsey
      end
    end
  end

  context "Reset Transcoder" do
    it "can reset a transcoder", unit_test: true do
      app.intercept do
        # response = Net::HTTP.get(URI("http://transcoders_endpoint_test.wowza.com/api/v1.3/transcoders/"))
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid3")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("started")

        transcoder_reset = transcoder.reset
        expect(transcoder_reset.success?).to be_truthy
        expect(transcoder_reset.state).to eq("resetting")

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy
        expect(transcoder_state.state).to eq("resetting")
      end
    end

    it "can reset a transcoder and wait for the started state", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid3")

        expect(transcoder.success?).to be_truthy
        expect(transcoder.state.state).to eq("started")

        transcoder_state = transcoder.reset(poll_interval: 1) do |wait_state, transcoder_state|
          if wait_state == :waiting
            expect(transcoder_state.state).to eq("resetting")
          elsif wait_state == :complete
            expect(transcoder_state.state).to eq("started")
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can reset a transcoder and timeout if the started state isn't reached", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid7")

        transcoder_state = transcoder.reset(poll_interval: 1, timeout: 1) do |wait_state, transcoder_state|
          if wait_state == :timeout
            expect(transcoder_state.state).not_to eq("started")
          elsif wait_state == :waiting
            # Don't need to test the waiting state, so we'll make it pass.
            expect(true).to be_truthy
          else
            # We shouldn't have gotten another wait state, so the test should
            # fail.
            expect(true).to be_falsey
          end
        end

        expect(transcoder_state.success?).to be_truthy
      end
    end

    it "can reset a transcoder and return an invalid state change instead of engaging the loop", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")

        expect(transcoder.success?).to be_truthy

        transcoder_state = transcoder.state
        expect(transcoder_state.success?).to be_truthy

        transcoder_state = transcoder.reset do |wait_state, transcoder_state|
          # This should not execute, so put a failing test in if it does.
          expect(true).to be_falsey "This code should not have executed."
        end

        expect(transcoder_state.success?).to be_falsey
      end
    end

  end

  context "Other Transcoder Actions" do
    it "can request a thumbnail url", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")
        expect(transcoder.success?).to be_truthy

        thumbnail_url = transcoder.thumbnail_url
        expect(thumbnail_url.success?).to be_truthy
        expect(thumbnail_url.thumbnail_url).to eq("http://thumbnail_url.transcoders.cloud.wowza.com/uid4")
      end
    end

    it "can request stats", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")
        expect(transcoder.success?).to be_truthy

        stats = transcoder.stats
        expect(stats.success?).to be_truthy
      end
    end

    it "can enable all stream targets", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")
        # expect(transcoder.success?).to be_truthy

        enabled = transcoder.enable_all_stream_targets
        # expect(enabled.success?).to be_truthy
      end
    end

    it "can disable all stream targets", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        transcoder = client.transcoders.find("uid4")
        expect(transcoder.success?).to be_truthy

        disabled = transcoder.disable_all_stream_targets
        expect(disabled.success?).to be_truthy
      end
    end
  end
end
