####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/api_simulators/transcoder_simulator"
require "unit/api_simulators/output_simulator"
require "unit/api_simulators/output_stream_target_simulator"
require "unit/api_simulators/wowza_stream_target_simulator"

describe WscSdk::Endpoints::OutputStreamTargets do

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

  it "can list associated stream targets", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      output_app.intercept do
        output_list = transcoder.outputs.list
        output      = output_list[output_list.keys.first]

        app.intercept do
          list      = output.output_stream_targets.list

          expect(list.success?).to be_truthy
          expect(list.keys.length).to eq(2)
        end
      end
    end

  end

  it "can get an output stream target's details", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      output_app.intercept do
        output_list = transcoder.outputs.list
        output      = output_list[output_list.keys.first]

        app.intercept do
          output_stream_target = output.output_stream_targets.find("uid1")
          expect(output_stream_target.class).to eq(WscSdk::Models::OutputStreamTarget)
          expect(output_stream_target.output_id).to eq("uid1")
          expect(output_stream_target.stream_target_id).to eq("uid2")

          stream_target_app.intercept do
            stream_target = output_stream_target.stream_target
            expect(stream_target.id).to eq("uid2")
          end
        end
      end
    end
  end

  it "can add an output stream target association", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      output_app.intercept do
        output_list = transcoder.outputs.list
        output      = output_list[output_list.keys.first]

        stream_target_app.intercept do
          stream_target = client.stream_targets.wowza.find("uid2")

          app.intercept do
            output_stream_target                    = output.output_stream_targets.build
            output_stream_target.stream_target_id   = stream_target.id
            expect(output_stream_target.stream_target_id).to eq("uid2")

            saved = output.output_stream_targets.create(output_stream_target)
            expect(saved.success?).to be_truthy
            expect(saved.stream_target_id).to eq("uid2")
          end
        end
      end
    end
  end

  it "can update an output stream target association", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      output_app.intercept do
        output_list = transcoder.outputs.list
        output      = output_list[output_list.keys.first]

        stream_target_app.intercept do
          stream_target = client.stream_targets.wowza.find("uid2")

          app.intercept do
            output_stream_target                    = output.output_stream_targets.find('uid1')
            output_stream_target.stream_target_id   = stream_target.id
            expect(output_stream_target.stream_target_id).to eq("uid2")

            saved = output.output_stream_targets.update(output_stream_target)
            expect(saved.success?).to be_truthy
            expect(saved.stream_target_id).to eq("uid2")
          end
        end
      end
    end
  end

  it "can remove a stream target association", unit_test: true do
    transcoder_app.intercept do
      transcoder  = client.transcoders.find('uid1')

      output_app.intercept do
        output_list = transcoder.outputs.list
        output      = output_list[output_list.keys.first]

        app.intercept do
          output_stream_target = output.output_stream_targets.find("uid1")
          deleted = output.output_stream_targets.delete(output_stream_target)
          expect(deleted.success?).to be_truthy
        end
      end
    end
  end
end
