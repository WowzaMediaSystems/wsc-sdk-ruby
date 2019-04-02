####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/wowza_stream_target_simulator"


describe WscSdk::Endpoints::WowzaStreamTargets do

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


  it "can list associated wowza stream target", unit_test: true do
    app.intercept do
      list = client.stream_targets.wowza.list

      expect(list.success?).to be_truthy
      expect(list.keys.length).to eq(5)
    end
  end


  it "can get an wowza stream target's details", unit_test: true do
    app.intercept do
      wowza_target      = client.stream_targets.wowza.find('uid1')
      expect(wowza_target.success?).to be_truthy
      expect(wowza_target.class).to eq(WscSdk::Models::WowzaStreamTarget)
      expect(wowza_target.name).to eq("Wowza Akamai Cupertino Stream Target 1")
      expect(wowza_target.type).to eq("wowza")
      expect(wowza_target.location).to be_nil
      expect(wowza_target.use_secure_ingest).to be_falsey
      expect(wowza_target.use_cors).to be_falsey
      expect(wowza_target.stream_name).to eq("test_stream_name")
      expect(wowza_target.secure_ingest_query_param).to be_nil
      expect(wowza_target.username).to eq("username")
      expect(wowza_target.password).to eq("password")
      expect(wowza_target.primary_url).to eq("http://test_url/primary")
      expect(wowza_target.backup_url).to eq("http://test_url/primary")
      expect(wowza_target.hds_playback_url).to eq("http://test_url/primary/hds")
      expect(wowza_target.hls_playback_url).to eq("http://test_url/primary/hls")
      expect(wowza_target.rtmp_playback_url).to eq("http://test_url/primary/rtmp")
      expect(wowza_target.connection_code).to eq("abcd1234")
      expect(wowza_target.connection_code_expires_at).to eq("2019-01-01 12:00:00")
      expect(wowza_target.created_at).to eq("2019-01-01 12:00:00")
      expect(wowza_target.updated_at).to eq("2019-01-01 12:00:00")
    end
  end

  it "can create an wowza stream target", unit_test: true do
    app.intercept do
      wowza_target_data = WscSdk::Templates::WowzaStreamTarget.akamai_cupertino("My New Wowza Stream Target", false, false)
      wowza_target      = client.stream_targets.wowza.build(wowza_target_data)

      expect(wowza_target.id).to be_nil
      wowza_target      = client.stream_targets.wowza.create(wowza_target)

      expect(wowza_target.success?).to be_truthy
      expect(wowza_target.id).not_to be_nil
    end
  end

  it "can update an wowza stream target", unit_test: true do
    app.intercept do
      wowza_targets   = client.stream_targets.wowza.list
      wowza_target    = wowza_targets[wowza_targets.keys.last]

      wowza_target.name = "New Name"
      wowza_target      = client.stream_targets.wowza.update(wowza_target)

      expect(wowza_target.success?).to be_truthy
      expect(wowza_target.id).not_to be_nil
      expect(wowza_target.name).to eq("New Name")
    end
  end

  it "can delete an wowza stream target", unit_test: true do
    app.intercept do
      wowza_targets = client.stream_targets.wowza.list
      wowza_target  = wowza_targets[wowza_targets.keys.last]

      expect(wowza_target.delete.success?).to be_truthy
      expect(wowza_target.id).to be_nil
    end
  end

end
