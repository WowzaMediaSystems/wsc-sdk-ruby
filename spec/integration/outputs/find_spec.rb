####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "output .find", :integration_test => true do
  
  t_name                  = "auto sdk hd find"
  name                    = "Video+Audio=2600+128, high, 1280 x 720"
  source_url              = "rtmp://0.0.0.0/live"
  id                      = /\w{8}/
  
  stream_format           = "audiovideo"
  passthrough_video       = false
  passthrough_audio       = false
  aspect_ratio_height     = 720
  aspect_ratio_width      = 1280
  bitrate_audio           = 128
  bitrate_video           = 2600
  h264_profile            = "high"
  framerate_reduction     = "0"
  keyframes               = "follow_source"

  before :all do
    @transcoders      = $client.transcoders
    @data = WscSdk::Templates::Transcoder.rtmp_pull(t_name, source_url)
    @transcoder = @transcoders.build(@data)
    @response = @transcoder.save
    output_model_attributes(@transcoder, "transcoder: #{@transcoder.name}")
    @t_id = @transcoder.id
    
    @outputs = @transcoder.outputs
    @data = WscSdk::Templates::Output.hd
    @output = @outputs.build(@data)
    @response = @output.save
    @id = @output.id
    @find = @outputs.find(@id)
    output_model_attributes(@find, "output find: #{@find.name}")
  end

  it "had success" do
    expect(@find.success?).to eq(true)
  end
  
  it "has expected id" do
    expect(@find.id).to match(@id)
  end

  it "has expected name" do
    expect(@find.name).to eq(name)
  end

  it "has expected transcoder_id" do
    expect(@find.transcoder_id).to eq(@t_id)
  end

  it "has expected stream_format" do
    expect(@find.stream_format).to eq(stream_format)
  end

  it "has expected passthrough_video" do
    expect(@find.passthrough_video).to eq(passthrough_video)
  end

  it "has expected passthrough_audio" do
    expect(@find.passthrough_audio).to eq(passthrough_audio)
  end

  it "has expected aspect_ratio_height" do
    expect(@find.aspect_ratio_height).to eq(aspect_ratio_height)
  end

  it "has expected aspect_ratio_width" do
    expect(@find.aspect_ratio_width).to eq(aspect_ratio_width)
  end

  it "has expected bitrate_audio" do
    expect(@find.bitrate_audio).to eq(bitrate_audio)
  end

  it "has expected bitrate_video" do
    expect(@find.bitrate_video).to eq(bitrate_video)
  end

  it "has expected h264_profile" do
    expect(@find.h264_profile).to eq(h264_profile)
  end

  it "has expected framerate_reduction" do
    expect(@find.framerate_reduction).to eq(framerate_reduction)
  end

  it "has expected keyframes" do
    expect(@find.keyframes).to eq(keyframes)
  end

  after :all do
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
