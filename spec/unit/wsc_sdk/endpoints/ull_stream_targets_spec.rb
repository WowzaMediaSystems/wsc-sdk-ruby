####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/ull_stream_target_simulator"

describe WscSdk::Endpoints::UllStreamTargets do

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


  it "can list associated custom stream target", unit_test: true do
    app.intercept do
      list = client.stream_targets.ull.list

      expect(list.success?).to be_truthy
      expect(list.keys.length).to eq(4)
    end
  end


  it "can get an custom stream target's details", unit_test: true do
    app.intercept do
      ull_target      = client.stream_targets.ull.find('uid1')
      expect(ull_target.success?).to be_truthy
      expect(ull_target.class).to eq(WscSdk::Models::UllStreamTarget)
      expect(ull_target.name).to eq("Ull Pull Stream Target 1")
      expect(ull_target.type).to eq("ull")
      expect(ull_target.source_delivery_method).to eq(WscSdk::Enums::DeliveryMethod::PULL)
      expect(ull_target.stream_name).to eq("0I0q1bjZhRzZtfSdv4TpCnlmwQT16239")
      expect(ull_target.enabled).to eq(true)
      expect(ull_target.enable_hls).to eq(false)
      expect(ull_target.state).to eq("stopped")
      expect(ull_target.connection_code).to eq("abcd1234")
      expect(ull_target.connection_code_expires_at).to eq("2019-01-01 12:00:00")
      expect(ull_target.playback_urls).to be_a(Hash)
      expect(ull_target.primary_url).to eq("rtmp://origin.cdn.wowza.com:1935/live/0I0q1bjZhRzZtfSdv4TpCnlmwQT16239")
      expect(ull_target.created_at).to eq("2019-01-01 12:00:00")
      expect(ull_target.updated_at).to eq("2019-01-01 12:00:00")
    end
  end

  it "can create an custom stream target", unit_test: true do
    app.intercept do
      ull_target_data = WscSdk::Templates::UllStreamTarget.pull("My New ULL Stream Target", "http://custom_url.com")
      ull_target      = client.stream_targets.ull.build(ull_target_data)

      expect(ull_target.id).to be_nil
      ull_target      = client.stream_targets.ull.create(ull_target)

      expect(ull_target.success?).to be_truthy
      expect(ull_target.id).not_to be_nil
    end
  end

  it "can update an custom stream target", unit_test: true do
    app.intercept do
      ull_targets     = client.stream_targets.ull.list
      ull_target      = ull_targets[ull_targets.keys.last]
      ull_target.name = "New Name"
      ull_target      = client.stream_targets.ull.update(ull_target)

      expect(ull_target.success?).to be_truthy
      expect(ull_target.id).not_to be_nil
      expect(ull_target.name).to eq("New Name")
    end
  end

  it "can delete a custom stream target", unit_test: true do
    app.intercept do
      ull_targets = client.stream_targets.ull.list
      ull_target  = ull_targets[ull_targets.keys.last]

      expect(ull_target.delete.success?).to be_truthy
      expect(ull_target.id).to be_nil
    end
  end

end
