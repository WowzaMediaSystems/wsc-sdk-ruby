require 'integration/spec_helper'

describe "transcoder .save rtsp pull", :integration_test => true do
  
  name                    = "auto sdk rtsp pull"
  source_url              = "rtsp://0.0.0.0/live"
  id                      = /\w{8}/
  transcoder_type         = 'transcoded'
  billing_mode            = 'pay_as_you_go'
  protocol                = 'rtsp'
  delivery_method         = 'pull'
  recording               = false
  buffer_size             = 4000
  stream_smoother         = false
  low_latency             = false
  idle_timeout            = 1200
  disable_authentication  = false


  before :all do
    @transcoders      = $client.transcoders
    @data = WscSdk::Templates::Transcoder.rtsp_pull(name, source_url)
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

  it "has expected source_url" do
    expect(@transcoder.source_url).to eq(source_url)
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
  end


end
