####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/custom_stream_target_simulator"

describe WscSdk::Models::CustomStreamTarget do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { CustomStreamTargetSimulator.new }
  let(:app)       { simulator.app }

  #-----------------------------------------------------------------------------
  #  _____       _
  # |_   _|__ __| |_ ___
  #   | |/ -_|_-<  _(_-<
  #   |_|\___/__/\__/__/
  #
  #-----------------------------------------------------------------------------

  it "is configured as expected", unit_test: true do
    stream_targets        = client.stream_targets
    custom_stream_target   = stream_targets.custom.build

    expect_attribute custom_stream_target, :id,                 :string,    access: :read
    expect_attribute custom_stream_target, :name,               :string,    required: true
    expect_attribute custom_stream_target, :type,               :string,    access: :read
    expect_attribute custom_stream_target, :provider,           :string
    expect_attribute custom_stream_target, :stream_name,        :string
    expect_attribute custom_stream_target, :username,           :string
    expect_attribute custom_stream_target, :password,           :string
    expect_attribute custom_stream_target, :primary_url,        :string
    expect_attribute custom_stream_target, :backup_url,         :string
    expect_attribute custom_stream_target, :hds_playback_url,   :string
    expect_attribute custom_stream_target, :hls_playback_url,   :string
    expect_attribute custom_stream_target, :rtmp_playback_url,  :string
    expect_attribute custom_stream_target, :created_at,         :datetime,  access: :read
    expect_attribute custom_stream_target, :updated_at,         :datetime,  access: :read

  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      app.intercept do
        custom_target_data = WscSdk::Templates::CustomStreamTarget.akamai_hls("My New Custom Stream Target", "https://custom_url.com", "stream10")
        custom_target      = client.stream_targets.custom.build(custom_target_data)

        expect(custom_target.id).to be_nil
        expect(custom_target.save.success?).to be_truthy
        expect(custom_target.id).not_to be_nil
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      app.intercept do
        custom_targets = client.stream_targets.custom.list
        custom_target  = custom_targets[custom_targets.keys.last]

        custom_target.name = "This is an updated Wowza stream target"

        expect(custom_target.save.success?).to be_truthy
        expect(custom_target.id).not_to be_nil
        expect(custom_target.name).to eq("This is an updated Wowza stream target")
      end

    end

    it "can delete itself when its an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        custom_targets = client.stream_targets.custom.list
        custom_target  = custom_targets[custom_targets.keys.last]

        expect(custom_target.delete.success?).to be_truthy
        expect(custom_target.id).to be_nil
      end

    end
  end

end
