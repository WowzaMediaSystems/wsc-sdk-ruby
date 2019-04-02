require "unit/spec_helper"
require "unit/api_simulators/live_stream_simulator"


describe WscSdk::Endpoints::LiveStreams do

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


  it "can list live streams", unit_test: true do
    app.intercept do
      live_streams = client.live_streams.list

      expect(live_streams.success?).to be_truthy
      expect(live_streams.keys.length).to eq(8)
      expect(live_streams["uid1"].class).to eq(WscSdk::Models::LiveStream)
      expect(live_streams["uid1"].name).to eq("WSE Live Stream 1")
    end
  end

  it "can get a live_stream's details", unit_test: true do
    app.intercept do
      live_stream  = client.live_streams.find("uid1")

      expect(live_stream.success?).to be_truthy
      expect(live_stream.class).to eq(WscSdk::Models::LiveStream)
      expect(live_stream.name).to eq("WSE Live Stream 1")
    end
  end

  it "can create a live stream", unit_test: true do
    app.intercept do
      live_stream      = client.live_streams.build(simulator.new_rtmp_pull_live_stream)

      expect(live_stream.id).to be_nil
      live_stream      = client.live_streams.create(live_stream)

      expect(live_stream.success?).to be_truthy
      expect(live_stream.id).not_to be_nil
    end
  end

  it "can update a live stream", unit_test: true do
    app.intercept do
      live_streams = client.live_streams.list
      live_stream  = live_streams[live_streams.keys.last]

      live_stream.name = "This is an updated live_stream"
      live_stream      = client.live_streams.update(live_stream)
      expect(live_stream.success?).to be_truthy
      expect(live_stream.id).not_to be_nil
      expect(live_stream.name).to eq("This is an updated live_stream")
    end
  end

  it "can delete a live stream", unit_test: true do
    app.intercept do
      live_streams = client.live_streams.list
      live_stream  = live_streams[live_streams.keys.last]

      expect(live_stream.delete.success?).to be_truthy
      expect(live_stream.id).to be_nil
    end
  end

end
