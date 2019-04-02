####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "output .update", :integration_test => true do
  
  t_name                  = "auto sdk update"
  name                    = "Video+Audio=2600+128, high, 1280 x 720"
  updated_name            = "Video+Audio=1600+128, main, 854 x 480"
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

  updated_aspect_ratio_height     = 480
  updated_aspect_ratio_width      = 854
  updated_bitrate_audio           = 128
  updated_bitrate_video           = 1600

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
  
  describe "update output to different format" do
    before :all do
      updated_data = WscSdk::Templates::Output.sd_wide
      @output.ingest_attributes(updated_data)
      @response = @outputs.update(@output)
      output_model_attributes(@output, "update output: #{@output.name}")
    end
    
    it "had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "has expected updated_name" do
      expect(@output.name).to eq(updated_name)
    end
  
    it "has expected transcoder_id" do
      expect(@output.transcoder_id).to eq(@t_id)
    end
  
    it "has expected aspect_ratio_height" do
      expect(@output.aspect_ratio_height).to eq(updated_aspect_ratio_height)
    end
  
    it "has expected aspect_ratio_width" do
      expect(@output.aspect_ratio_width).to eq(updated_aspect_ratio_width)
    end
  
    it "has expected bitrate_audio" do
      expect(@output.bitrate_audio).to eq(updated_bitrate_audio)
    end
  
    it "has expected bitrate_video" do
      expect(@output.bitrate_video).to eq(updated_bitrate_video)
    end
  
end

  after :all do
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
