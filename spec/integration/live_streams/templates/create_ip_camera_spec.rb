####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "live_stream .save ip_camera", :integration_test => true do
  
  name          = "auto sdk ip_camera"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtsp://10.0.0.1/live"
  primary_server  = /rtsp:\/\/.+\.entrypoint\.cloud\.wowza\.com\//
  host_port     = 1935
  stream_name   = /\w{8}/
  encoder       = "ipcamera"
  delivery_method = "pull"  ## TODO  ######### should push be the default by the railsapi?
  delivery_type   = "single-bitrate"
  target_delivery_protocol  = "hls-https"
  use_stream_source = false

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.ip_camera(name, aspect_ratio_width, aspect_ratio_height, source_url)
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
  
  after :all do
    response = @live_streams.delete(@live_stream)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end


end
