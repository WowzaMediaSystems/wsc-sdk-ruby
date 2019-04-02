require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"
require "unit/api_simulators/output_simulator"

describe WscSdk::Endpoints::Outputs do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:transcoder_simulator)  { TranscoderSimulator.new }
  let(:transcoder_app)        { transcoder_simulator.app }
  let(:simulator)             { OutputSimulator.new }
  let(:app)                   { simulator.app }

  #-----------------------------------------------------------------------------
  #  _____       _
  # |_   _|__ __| |_ ___
  #   | |/ -_|_-<  _(_-<
  #   |_|\___/__/\__/__/
  #
  #-----------------------------------------------------------------------------

  it "can list associated outputs", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      app.intercept do
        list = transcoder.outputs.list

        expect(list.success?).to be_truthy
        expect(list.keys.length).to eq(5)
      end
    end
  end


  it "can get an output's details", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      app.intercept do
        output      = transcoder.outputs.find('uid1')
        expect(output.success?).to be_truthy
        expect(output.class).to eq(WscSdk::Models::Output)
        expect(output.name).to eq("Output Name is Generated")
      end
    end
  end

  it "can create an output", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      app.intercept do
        output_data     = WscSdk::Templates::Output.full_hd
        output          = transcoder.outputs.build(output_data)

        expect(output.id).to be_nil
        output          = transcoder.outputs.create(output)

        expect(output.success?).to be_truthy
        expect(output.id).not_to be_nil
      end
    end
  end

  it "can update an output", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      app.intercept do
        outputs     = transcoder.outputs.list
        output      = outputs[outputs.keys.last]

        output.aspect_ratio_width = 432
        output                    = transcoder.outputs.update(output)
        expect(output.success?).to be_truthy
        expect(output.id).not_to be_nil
        expect(output.name).to eq("Output Name is Generated")
        expect(output.aspect_ratio_width).to eq(432)
      end
    end
  end

  it "can delete an output", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      app.intercept do
        outputs     = transcoder.outputs.list
        output      = outputs[outputs.keys.last]

        expect(output.delete.success?).to be_truthy
        expect(output.id).to be_nil
      end
    end
  end
end
