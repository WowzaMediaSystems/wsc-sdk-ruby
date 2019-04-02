####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/ull_stream_target_simulator"

describe WscSdk::Models::UllStreamTarget do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { UllStreamTargetSimulator.new }
  let(:app)       { simulator.app }

  #-----------------------------------------------------------------------------
  #  _____       _
  # |_   _|__ __| |_ ___
  #   | |/ -_|_-<  _(_-<
  #   |_|\___/__/\__/__/
  #
  #-----------------------------------------------------------------------------


  it "is configured as expected", unit_test: true do
    stream_targets      = client.stream_targets
    ull_stream_target   = stream_targets.ull.build

    expect_attribute ull_stream_target, :id,                          :string,    access: :read
    expect_attribute ull_stream_target, :name,                        :string,    required: true
    expect_attribute ull_stream_target, :source_delivery_method,      :string,    required: true,   access: :new_model_access
    expect_attribute ull_stream_target, :source_url,                  :string,    required: :source_url_required_if_pull
    expect_attribute ull_stream_target, :type,                        :string,    access: :read
    expect_attribute ull_stream_target, :provider,                    :string
    expect_attribute ull_stream_target, :enabled,                     :boolean
    expect_attribute ull_stream_target, :enable_hls,                  :boolean
    expect_attribute ull_stream_target, :state,                       :string
    expect_attribute ull_stream_target, :ingest_ip_whitelist,         :array
    expect_attribute ull_stream_target, :region_override,             :string
    expect_attribute ull_stream_target, :stream_name,                 :string,    access: :read
    expect_attribute ull_stream_target, :primary_url,                 :string,    access: :read
    expect_attribute ull_stream_target, :playback_urls,               :hash,      access: :read
    expect_attribute ull_stream_target, :connection_code,             :string,    access: :read
    expect_attribute ull_stream_target, :connection_code_expires_at,  :datetime,  access: :read
    expect_attribute ull_stream_target, :created_at,                  :datetime,  access: :read
    expect_attribute ull_stream_target, :updated_at,                  :datetime,  access: :read

  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      app.intercept do
        ull_target_data = WscSdk::Templates::UllStreamTarget.pull("My New Wowza Stream Target", "rtmp://source_url.com")
        ull_target      = client.stream_targets.ull.build(ull_target_data)

        expect(ull_target.id).to be_nil
        expect(ull_target.save.success?).to be_truthy
        expect(ull_target.id).not_to be_nil
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      app.intercept do
        ull_targets = client.stream_targets.ull.list
        ull_target  = ull_targets[ull_targets.keys.last]

        ull_target.name = "This is an updated Ull stream target"

        expect(ull_target.save.success?).to be_truthy
        expect(ull_target.id).not_to be_nil
        expect(ull_target.name).to eq("This is an updated Ull stream target")
      end

    end

    it "can delete itself when its an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        ull_targets = client.stream_targets.ull.list
        ull_target  = ull_targets[ull_targets.keys.last]

        expect(ull_target.delete.success?).to be_truthy
        expect(ull_target.id).to be_nil
      end

    end
  end

end
