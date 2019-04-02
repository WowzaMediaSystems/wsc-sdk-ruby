####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "transcoder .save rtmp push", :integration_test => true do
  
  name                    = "auto sdk rtmp push"
  id                      = /\w{8}/
  transcoder_type         = 'transcoded'
  billing_mode            = 'pay_as_you_go'
  protocol                = 'rtmp'
  delivery_method         = 'push'
  recording               = false
  stream_source_id        = nil
  buffer_size             = 4000
  stream_smoother         = false
  low_latency             = false
  idle_timeout            = 1200
  disable_authentication  = false

  before :all do
    stream_source_json = {
      "stream_source_akamai": {
        "name": "Auto sdk stream Source",
        "location_method": "region",
        "location": "us_west_california"
      }
    }
    stream_source = $client.request_endpoint(:post, "stream_sources/akamai", stream_source_json)
    if stream_source.has_key?("meta") ## if error creating akamai stream source
      @stream_source_id = "zzzllvjf"  ## use hard coded value
    else
      @stream_source_id = stream_source["stream_source_akamai"]["id"]
      @ss_cleanup = @stream_source_id.to_s
    end
    @transcoders      = $client.transcoders
    @data = WscSdk::Templates::Transcoder.rtmp_push(name, @stream_source_id)
    @transcoder = @transcoders.build(@data)
    @response = @transcoder.save
    handle_api_error(@response, "There was an error creating transcoder") unless @response.success?
    output_model_attributes(@transcoder, "transcoder: #{@transcoder.name}")
  end
  
  it "had success" do
    expect(@transcoder.success?).to eq(true)
  end
  
  it "has valid id" do
    expect(@transcoder.id).to match(id)
  end

  it "has expected name" do
    expect(@transcoder.name).to eq(name)
  end

  it "has expected stream_source_id" do
    expect(@transcoder.stream_source_id).to eq(@stream_source_id)
  end

  it "has expected transcoder_type" do
    expect(@transcoder.transcoder_type).to eq(transcoder_type)
  end

  it "has expected billing_mode" do
    expect(@transcoder.billing_mode).to eq(billing_mode)
  end

  it "has expected protocol" do
    expect(@transcoder.protocol).to eq(protocol)
  end

  it "has expected delivery_method" do
    expect(@transcoder.delivery_method).to eq(delivery_method)
  end

  it "has expected recording" do
    expect(@transcoder.recording).to eq(recording)
  end

  it "has expected buffer_size" do
    expect(@transcoder.buffer_size).to eq(buffer_size)
  end

  it "has expected stream_smoother" do
    expect(@transcoder.stream_smoother).to eq(stream_smoother)
  end

  it "has expected low_latency" do
    expect(@transcoder.low_latency).to eq(low_latency)
  end

  it "has expected idle_timeout" do
    expect(@transcoder.idle_timeout).to eq(idle_timeout)
  end

  it "has expected disable_authentication" do
    expect(@transcoder.disable_authentication).to eq(disable_authentication)
  end

  after :all do
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
    $client.request_endpoint(:delete, "stream_sources/akamai/#{@ss_cleanup}")
  end


end
