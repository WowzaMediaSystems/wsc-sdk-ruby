require 'integration/spec_helper'

describe "live_stream .save rtmp pull", :integration_test => true do
  
  name          = "auto sdk rtmp pull"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtmp://0.0.0.0/live"
  delivery_method = "pull"

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.rtmp_pull(name, aspect_ratio_width, aspect_ratio_height, source_url)
    @live_stream = @live_streams.build(ls_data)
    @response = @live_stream.save
    handle_api_error(@response, "There was an error creating live streams") unless @response.success?
    output_model_attributes(@live_stream, "Live Stream: #{@live_stream.name}")
  end

  it "had success" do
    expect(@live_stream.success?).to eq(true)
  end

  it "has expected name" do
    expect(@live_stream.name).to eq(name)
  end

  it "has expected source_url" do
    expect(@live_stream.source_connection_information[:source_url]).to eq(source_url)
  end

  it "has expected delivery_method" do
    expect(@live_stream.delivery_method).to eq(delivery_method)
  end

  it "has expected aspect_ratio_width" do
    expect(@live_stream.aspect_ratio_width).to eq(aspect_ratio_width)
  end

  it "has expected aspect_ratio_height" do
    expect(@live_stream.aspect_ratio_height).to eq(aspect_ratio_height)
  end
  
  after :all do
    @response = @live_streams.delete(@live_stream)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end


end
