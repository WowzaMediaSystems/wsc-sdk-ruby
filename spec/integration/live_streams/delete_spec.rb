require 'integration/spec_helper'

describe "live_stream .delete", :integration_test => true do
  
  name          = "auto sdk delete"
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
    @id = @live_stream.id
    @list = @live_streams.list
  end
  
  it "newly created live stream is in .list" do
    expect(@list.has_key?(@id)).to eq(true)
  end
  
  describe ".delete live stream" do
    before :all do
      @response = @live_streams.delete(@live_stream)
      @list = @live_streams.list
    end

    it ".delete had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "deleted live stream has been deleted as expected" do
      expect(@list.has_key?(@id)).to eq(false)
    end
    
  end

  after :all do
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end

end
