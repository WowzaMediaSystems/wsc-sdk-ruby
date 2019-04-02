require "unit/spec_helper"
require "unit/api_simulators/stream_target_simulator"


describe WscSdk::Endpoints::StreamTargets do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:simulator) { StreamTargetSimulator.new }
  let(:app)       { simulator.app }

  #-----------------------------------------------------------------------------
  #  _____       _
  # |_   _|__ __| |_ ___
  #   | |/ -_|_-<  _(_-<
  #   |_|\___/__/\__/__/
  #
  #-----------------------------------------------------------------------------

  it "can list stream targets", unit_test: true do
    app.intercept do
      stream_targets = client.stream_targets.list

      expect(stream_targets.success?).to be_truthy
      expect(stream_targets.keys.length).to eq(6)
      expect(stream_targets["uid1"].class).to eq(WscSdk::Models::StreamTarget)
      expect(stream_targets["uid1"].name).to eq("Wowza Stream Target 1")
    end
  end

  it "cannnot find, build, create, update, delete stream targets", unit_test: true do
    expect{ client.stream_targets.find('abc') }.to raise_error(Exception)
    expect{ client.stream_targets.build }.to raise_error(Exception)
    expect{ client.stream_targets.create('not a stream target') }.to raise_error(Exception)
    expect{ client.stream_targets.update('not a stream target') }.to raise_error(Exception)
    expect{ client.stream_targets.delete('abc') }.to raise_error(Exception)
  end
end
