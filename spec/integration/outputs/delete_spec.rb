####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "output .delete", :integration_test => true do
  
  t_name                  = "auto sdk delete"
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
    @output1 = @outputs.build(@data)
    @response = @output1.save
    @id1 = @output1.id
    
    @data = WscSdk::Templates::Output.sd_wide
    @output2 = @outputs.build(@data)
    @response = @output2.save
    @id2 = @output2.id
    
    @list = @outputs.list
  end

  it "newly created output1 is in .list" do
    expect(@list.has_key?(@id1)).to eq(true)
  end
  
  it "newly created output2 is in .list" do
    expect(@list.has_key?(@id2)).to eq(true)
  end
  
  describe ".delete output 1" do
    before :all do
      @response = @outputs.delete(@output1)
      @list = @outputs.list
    end
      
    it ".delete had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "output1 is NOT in .list" do
      expect(@list.has_key?(@id1)).to eq(false)
    end
    
    it "output2 is in .list" do
      expect(@list.has_key?(@id2)).to eq(true)
    end
    
  end
  
  after :all do
    handle_api_error(@response, "There was an error deleting output") unless @response.success?
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
