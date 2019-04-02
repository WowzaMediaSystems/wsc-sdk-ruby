require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"
require "unit/api_simulators/output_simulator"
require "unit/api_simulators/output_stream_target_simulator"
require "unit/api_simulators/wowza_stream_target_simulator"

describe WscSdk::Models::OutputStreamTarget do

  let(:client)    { WscSdk::Client.new }

  #-----------------------------------------------------------------------------
  #    _   ___ ___   ___ _           _      _   _
  #   /_\ | _ \_ _| / __(_)_ __ _  _| |__ _| |_(_)___ _ _
  #  / _ \|  _/| |  \__ \ | '  \ || | / _` |  _| / _ \ ' \
  # /_/ \_\_| |___| |___/_|_|_|_\_,_|_\__,_|\__|_\___/_||_|
  #
  #-----------------------------------------------------------------------------

  let(:transcoder_simulator)    { TranscoderSimulator.new }
  let(:transcoder_app)          { transcoder_simulator.app }
  let(:output_simulator)        { OutputSimulator.new }
  let(:output_app)              { output_simulator.app }
  let(:stream_target_simulator) { WowzaStreamTargetSimulator.new }
  let(:stream_target_app)       { stream_target_simulator.app }
  let(:simulator)               { OutputStreamTargetSimulator.new }
  let(:app)                     { simulator.app }

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

      output_app.intercept do
        output      = transcoder.outputs.find("uid1")

        output_stream_target = output.output_stream_targets.build
        expect_attribute output_stream_target, :id,                            :string,         access: :read
        expect_attribute output_stream_target, :output_id,                     :string,         access: :read
        expect_attribute output_stream_target, :stream_target_id,              :string
        expect_attribute output_stream_target, :use_stream_target_backup_url,  :boolean
        expect_attribute output_stream_target, :stream_target,                 :stream_target,  access: :read
      end
    end
  end

  context "Model Save" do
    it "can create itself when it's a new model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")


        output_app.intercept do
          output      = transcoder.outputs.find("uid1")

          stream_target_app.intercept do
            stream_target = client.stream_targets.wowza.find("uid2")
            app.intercept do
              output_stream_target                = output.output_stream_targets.build
              output_stream_target.stream_target  = stream_target

              expect(output_stream_target.id).to be_nil
              expect(output_stream_target.save.success?).to be_truthy
              expect(output_stream_target.id).not_to be_nil
            end
          end
        end
      end
    end

    it "can update itself when it's an existing model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")

        output_app.intercept do
          output      = transcoder.outputs.find("uid1")

          stream_target_app.intercept do
            stream_target = client.stream_targets.wowza.find("uid2")
            app.intercept do
              output_stream_target                = output.output_stream_targets.find("uid1")
              output_stream_target.stream_target  = stream_target

              expect(output_stream_target.id).not_to be_nil
              expect(output_stream_target.save.success?).to be_truthy
            end
          end
        end
      end
    end

    it "can delete itself when its an existing model", unit_test: true do
      transcoder_app.intercept do
        transcoder  = client.transcoders.find("uid1")

        output_app.intercept do
          output     = transcoder.outputs.find("uid1")

          app.intercept do
            list                  = output.output_stream_targets.list
            output_stream_target  = list[list.keys.last]

            expect(output_stream_target.delete.success?).to be_truthy
            expect(output_stream_target.id).to be_nil
          end
        end
      end
    end
  end
end
