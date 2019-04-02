require 'integration/spec_helper'

describe "live_stream .save gocoder", :integration_test => true do
  
  name          = "auto sdk gocoder"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  encoder       = "wowza_gocoder"
  delivery_method = "push"
  delivery_type   = "single-bitrate"
  target_delivery_protocol  = "hls-https"
  use_stream_source = false
  connection_code_regex = /\w{6}/

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.gocoder(name, aspect_ratio_width, aspect_ratio_height)
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

  it "has expected encoder" do
    expect(@live_stream.encoder).to eq(encoder)
  end

  it "has expected delivery_method" do
    expect(@live_stream.delivery_method).to eq(delivery_method)
  end

  it "has expected delivery_type" do
    expect(@live_stream.delivery_type).to eq(delivery_type)
  end

  it "has expected target_delivery_protocol" do
    expect(@live_stream.target_delivery_protocol).to eq(target_delivery_protocol)
  end

  it "has expected use_stream_source" do
    expect(@live_stream.use_stream_source).to eq(false)
  end

  it "has expected aspect_ratio_width" do
    expect(@live_stream.aspect_ratio_width).to eq(aspect_ratio_width)
  end

  it "has expected aspect_ratio_height" do
    expect(@live_stream.aspect_ratio_height).to eq(aspect_ratio_height)
  end
  
  it "has valid connection_code" do
    expect(@live_stream.connection_code).to match(connection_code_regex)
  end
  
  after :all do
    response = @live_streams.delete(@live_stream)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end


end
