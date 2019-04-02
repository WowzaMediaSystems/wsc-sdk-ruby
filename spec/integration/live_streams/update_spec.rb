####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "live_stream .update ", :integration_test => true do
  
  name          = "auto sdk update"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtmp://0.0.0.0/live"
  protocol      = "rtmp"
  delivery_method = "pull"

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.rtmp_pull(name, aspect_ratio_width, aspect_ratio_height, source_url)
    @live_stream = @live_streams.build(ls_data)
    @response = @live_stream.save
    handle_api_error(@response, "There was an error creating live streams") unless @response.success?
    output_model_attributes(@live_stream, "Live Stream: #{@live_stream.name}")
  end
  
  it "initial create had success" do
    expect(@response.success?).to eq(true)
  end

  it "has initial expected name" do
    expect(@live_stream.name).to eq(name)
  end
  
  describe "update live stream name" do
    updated_name = "auto sdk CHANGED"
    before :all do
      @live_stream.name = updated_name
      output_model_attributes(@live_stream, "Live Stream: #{@live_stream.name}")
      @response = @live_streams.update(@live_stream)
    end
    
    it "update had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "has expected updated name" do
      expect(@live_stream.name).to eq(updated_name)
    end
  end

  after :all do
    handle_api_error(@response, "There was an error updating live streams") unless @response.success?
    @response = @live_streams.delete(@live_stream)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end

end
