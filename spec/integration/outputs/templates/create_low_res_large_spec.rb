require 'integration/spec_helper'

describe "output .save low_res_large", :integration_test => true do
  
  t_name                  = "auto sdk save low_res_large"
  name                    = "Video+Audio=1024+128, main, 640 x 360"
  source_url              = "rtmp://0.0.0.0/live"
  id                      = /\w{8}/
  
  stream_format           = "audiovideo"
  passthrough_video       = false
  passthrough_audio       = false
  aspect_ratio_height     = 360
  aspect_ratio_width      = 640
  bitrate_audio           = 128
  bitrate_video           = 1024
  h264_profile            = "main"
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
    @data = WscSdk::Templates::Output.low_res_large
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
