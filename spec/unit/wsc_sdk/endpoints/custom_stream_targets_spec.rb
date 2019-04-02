require "unit/spec_helper"
require "unit/api_simulators/custom_stream_target_simulator"


describe WscSdk::Endpoints::CustomStreamTargets do

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


  it "can list associated custom stream target", unit_test: true do
    app.intercept do
      list = client.stream_targets.custom.list

      expect(list.success?).to be_truthy
      expect(list.keys.length).to eq(6)
    end
  end


  it "can get an custom stream target's details", unit_test: true do
    app.intercept do
      custom_target      = client.stream_targets.custom.find('uid1')
      expect(custom_target.success?).to be_truthy
      expect(custom_target.class).to eq(WscSdk::Models::CustomStreamTarget)
      expect(custom_target.name).to eq("Custom Akamai HD Stream Target 1")
      expect(custom_target.type).to eq("custom")
      expect(custom_target.stream_name).to eq("stream1")
      expect(custom_target.username).to eq("username")
      expect(custom_target.password).to eq("password")
      expect(custom_target.primary_url).to eq("http://primary_url.com")
      expect(custom_target.backup_url).to eq("http://test_url/primary")
      expect(custom_target.hds_playback_url).to eq("http://test_url/primary/hds")
      expect(custom_target.hls_playback_url).to eq("http://test_url/primary/hls")
      expect(custom_target.rtmp_playback_url).to eq("http://test_url/primary/rtmp")
      expect(custom_target.created_at).to eq("2019-01-01 12:00:00")
      expect(custom_target.updated_at).to eq("2019-01-01 12:00:00")
    end
  end

  it "can create an custom stream target", unit_test: true do
    app.intercept do
      custom_target_data = WscSdk::Templates::CustomStreamTarget.akamai_hls("My New Custom Stream Target", "http://custom_url.com", "stream9")
      custom_target      = client.stream_targets.custom.build(custom_target_data)

      expect(custom_target.id).to be_nil
      custom_target      = client.stream_targets.custom.create(custom_target)

      expect(custom_target.success?).to be_truthy
      expect(custom_target.id).not_to be_nil
    end
  end

  it "can update an custom stream target", unit_test: true do
    app.intercept do
      custom_targets   = client.stream_targets.custom.list
      custom_target    = custom_targets[custom_targets.keys.last]

      custom_target.name = "New Name"
      custom_target      = client.stream_targets.custom.update(custom_target)

      expect(custom_target.success?).to be_truthy
      expect(custom_target.id).not_to be_nil
      expect(custom_target.name).to eq("New Name")
    end
  end

  it "can delete an custom stream target", unit_test: true do
    app.intercept do
      custom_targets = client.stream_targets.custom.list
      custom_target  = custom_targets[custom_targets.keys.last]

      expect(custom_target.delete.success?).to be_truthy
      expect(custom_target.id).to be_nil
    end
  end

end
