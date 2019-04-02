require 'integration/spec_helper'

describe "live_stream .find", :integration_test => true do
  
  name          = "auto sdk find"
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
    @ls_find = @live_streams.find(@id)
  end
  
  it "had success" do
    expect(@ls_find.success?).to eq(true)
  end

  it "has expected id" do
    expect(@ls_find.id).to eq(@id)
  end

  it "has expected name" do
    expect(@ls_find.name).to eq(name)
  end

  after :all do
    handle_api_error(@ls_find, "There was an error finding live streams") unless @ls_find.success?
    @response = @live_streams.delete(@ls_find)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end

end
