####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "live_stream .save rtmp push", :integration_test => true do
  
  name          = "auto sdk rtmp push"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtmp://0.0.0.0/live"
  delivery_method = "push"
  primary_server  = /rtmp:\/\/.+\.entrypoint\.cloud\.wowza\.com\//
  host_port     = 1935
  stream_name   = /\w{8}/

  before :all do
    @live_streams      = $client.live_streams
    ls_data = WscSdk::Templates::LiveStream.rtmp_push(name, aspect_ratio_width, aspect_ratio_height)
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

  it "has expected primary_server" do
    expect(@live_stream.source_connection_information[:primary_server]).to match(primary_server)
  end
  
  it "has expected host_port" do
    expect(@live_stream.source_connection_information[:host_port]).to match(host_port)
  end

  it "has expected stream_name" do
    expect(@live_stream.source_connection_information[:stream_name]).to match(stream_name)
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
    response = @live_streams.delete(@live_stream)
    handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
  end


end
