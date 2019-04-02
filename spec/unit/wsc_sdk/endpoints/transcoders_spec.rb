require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"


describe WscSdk::Endpoints::Transcoders do

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


  it "can list transcoders", unit_test: true do
    app.intercept do
      transcoders = client.transcoders.list

      expect(transcoders.success?).to be_truthy
      expect(transcoders.keys.length).to eq(7)
      expect(transcoders["uid1"].class).to eq(WscSdk::Models::Transcoder)
      expect(transcoders["uid1"].name).to eq("Pull Transcoder 1")
    end
  end

  it "can get a transcoder's details", unit_test: true do
    app.intercept do
      transcoder  = client.transcoders.find("uid1")

      expect(transcoder.success?).to be_truthy
      expect(transcoder.class).to eq(WscSdk::Models::Transcoder)
      expect(transcoder.name).to eq("Pull Transcoder 1")
    end
  end

  it "can create a transcoder", unit_test: true do
    app.intercept do
      transcoder      = client.transcoders.build(simulator.new_pull_rtmp_transcoder)

      expect(transcoder.id).to be_nil
      transcoder      = client.transcoders.create(transcoder)

      expect(transcoder.success?).to be_truthy
      expect(transcoder.id).not_to be_nil
    end
  end

  it "can update a transcoder", unit_test: true do
    app.intercept do
      transcoders = client.transcoders.list
      transcoder  = transcoders[transcoders.keys.last]

      transcoder.name = "This is an updated transcoder"
      transcoder      = client.transcoders.update(transcoder)
      expect(transcoder.success?).to be_truthy
      expect(transcoder.id).not_to be_nil
      expect(transcoder.name).to eq("This is an updated transcoder")
    end
  end

  it "can delete a transcoder", unit_test: true do
    app.intercept do
      transcoders = client.transcoders.list
      transcoder  = transcoders[transcoders.keys.last]

      expect(transcoder.delete.success?).to be_truthy
      expect(transcoder.id).to be_nil
    end
  end

end
