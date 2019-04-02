####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "output .save full_hd", :integration_test => true do
  
  t_name                  = "auto sdk save full_hd"
  name                    = "Video+Audio=4000+128, high, 1920 x 1080"
  source_url              = "rtmp://0.0.0.0/live"
  id                      = /\w{8}/
  
  stream_format           = "audiovideo"
  passthrough_video       = false
  passthrough_audio       = false
  aspect_ratio_height     = 1080
  aspect_ratio_width      = 1920
  bitrate_audio           = 128
  bitrate_video           = 4000
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
    @data = WscSdk::Templates::Output.full_hd
    @output = @outputs.build(@data)
    @response = @output.save
    handle_api_error(@response, "There was an error creating output") unless @response.success?
    output_model_attributes(@output, "output: #{@output.name}")
  end

  it "had success" do
    expect(@output.success?).to eq(true)
  end
  
  it "has valid id" do
    expect(@output.id).to match(id)
  end

  it "has expected name" do
    expect(@output.name).to eq(name)
  end

  it "has expected transcoder_id" do
    expect(@output.transcoder_id).to eq(@t_id)
  end

  it "has expected stream_format" do
    expect(@output.stream_format).to eq(stream_format)
  end

  it "has expected passthrough_video" do
    expect(@output.passthrough_video).to eq(passthrough_video)
  end

  it "has expected passthrough_audio" do
    expect(@output.passthrough_audio).to eq(passthrough_audio)
  end

  it "has expected aspect_ratio_height" do
    expect(@output.aspect_ratio_height).to eq(aspect_ratio_height)
  end

  it "has expected aspect_ratio_width" do
    expect(@output.aspect_ratio_width).to eq(aspect_ratio_width)
  end

  it "has expected bitrate_audio" do
    expect(@output.bitrate_audio).to eq(bitrate_audio)
  end

  it "has expected bitrate_video" do
    expect(@output.bitrate_video).to eq(bitrate_video)
  end

  it "has expected h264_profile" do
    expect(@output.h264_profile).to eq(h264_profile)
  end

  it "has expected framerate_reduction" do
    expect(@output.framerate_reduction).to eq(framerate_reduction)
  end

  it "has expected keyframes" do
    expect(@output.keyframes).to eq(keyframes)
  end

  after :all do
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
