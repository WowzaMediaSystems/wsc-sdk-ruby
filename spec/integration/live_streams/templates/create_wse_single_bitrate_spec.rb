require 'integration/spec_helper'

describe "live_stream .save wse_single_bitrate", :integration_test => true do
  
  name                      = "auto sdk wse_single_bitrate"
  aspect_ratio_width        = 1280
  aspect_ratio_height       = 720
  delivery_method           = "push"

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.wse_single_bitrate(name, aspect_ratio_width, aspect_ratio_height)
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
