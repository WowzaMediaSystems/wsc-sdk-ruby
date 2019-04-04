####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"
require "unit/api_simulators/output_simulator"

describe WscSdk::Models::Output do

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

  it "is configured as expected", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find("uid1")
      output      = transcoder.outputs.build

      expect_attribute output, :id,                  :string,    access: :read
      expect_attribute output, :name,                :string,    access: :read
      expect_attribute output, :transcoder_id,       :string,    access: :read
      expect_attribute output, :stream_format,       :string
      expect_attribute output, :passthrough_video,   :boolean
      expect_attribute output, :passthrough_audio,   :boolean
      expect_attribute output, :aspect_ratio_height, :integer
      expect_attribute output, :aspect_ratio_width,  :integer
      expect_attribute output, :bitrate_audio,       :integer
      expect_attribute output, :bitrate_video,       :integer
      expect_attribute output, :h264_profile,        :string
      expect_attribute output, :framerate_reduction, :string
      expect_attribute output, :keyframes,           :string
      expect_attribute output, :created_at,          :datetime,  access: :read
      expect_attribute output, :updated_at,          :datetime,  access: :read
    end
  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")

        app.intercept do
          output_data = WscSdk::Templates::Output.full_hd
          output      = transcoder.outputs.build(output_data)

          expect(output.id).to be_nil
          expect(output.save.success?).to be_truthy
          expect(output.id).not_to be_nil
        end
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")

        app.intercept do
          outputs     = transcoder.outputs.list
          output      = outputs[outputs.keys.last]

          output.aspect_ratio_width = 432

          expect(output.save.success?).to be_truthy
          expect(output.id).not_to be_nil
          expect(output.aspect_ratio_width).to eq(432)
        end
      end
    end

    it "can delete itself when its an existing model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")

        app.intercept do
          outputs     = transcoder.outputs.list
          output      = outputs[outputs.keys.last]

          expect(output.delete.success?).to be_truthy
          expect(output.id).to be_nil
        end
      end
    end
  end
end
