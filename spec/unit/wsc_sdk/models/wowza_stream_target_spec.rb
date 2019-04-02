
require "unit/spec_helper"
require "unit/api_simulators/wowza_stream_target_simulator"

describe WscSdk::Models::WowzaStreamTarget do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { WowzaStreamTargetSimulator.new }
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
    wowza_stream_target   = stream_targets.wowza.build

    expect_attribute wowza_stream_target, :id,                          :string,    access: :read
    expect_attribute wowza_stream_target, :name,                        :string,    required: true
    expect_attribute wowza_stream_target, :type,                        :string,    access: :read
    expect_attribute wowza_stream_target, :provider,                    :string
    expect_attribute wowza_stream_target, :location,                    :string,    access: :new_location_access
    expect_attribute wowza_stream_target, :use_secure_ingest,           :boolean,   access: :new_model_access
    expect_attribute wowza_stream_target, :use_cors,                    :boolean,   access: :new_model_access
    expect_attribute wowza_stream_target, :stream_name,                 :string,    access: :read
    expect_attribute wowza_stream_target, :secure_ingest_query_param,   :string,    access: :read
    expect_attribute wowza_stream_target, :username,                    :string,    access: :read
    expect_attribute wowza_stream_target, :password,                    :string,    access: :read
    expect_attribute wowza_stream_target, :primary_url,                 :string,    access: :read
    expect_attribute wowza_stream_target, :backup_url,                  :string,    access: :read
    expect_attribute wowza_stream_target, :hds_playback_url,            :string,    access: :read
    expect_attribute wowza_stream_target, :hls_playback_url,            :string,    access: :read
    expect_attribute wowza_stream_target, :rtmp_playback_url,           :string,    access: :read
    expect_attribute wowza_stream_target, :connection_code,             :string,    access: :read
    expect_attribute wowza_stream_target, :connection_code_expires_at,  :datetime,  access: :read
    expect_attribute wowza_stream_target, :created_at,                  :datetime,  access: :read
    expect_attribute wowza_stream_target, :updated_at,                  :datetime,  access: :read

  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      app.intercept do
        wowza_target_data = WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("My New Wowza Stream Target", false, false)
        wowza_target      = client.stream_targets.wowza.build(wowza_target_data)

        expect(wowza_target.id).to be_nil
        expect(wowza_target.save.success?).to be_truthy
        expect(wowza_target.id).not_to be_nil
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      app.intercept do
        wowza_targets = client.stream_targets.wowza.list
        wowza_target  = wowza_targets[wowza_targets.keys.last]

        wowza_target.name = "This is an updated Wowza stream target"

        expect(wowza_target.save.success?).to be_truthy
        expect(wowza_target.id).not_to be_nil
        expect(wowza_target.name).to eq("This is an updated Wowza stream target")
      end

    end

    it "can delete itself when its an existing model", unit_test: true do
      app.intercept do
        client = WscSdk::Client.new
        wowza_targets = client.stream_targets.wowza.list
        wowza_target  = wowza_targets[wowza_targets.keys.last]

        expect(wowza_target.delete.success?).to be_truthy
        expect(wowza_target.id).to be_nil
      end

    end
  end

end
