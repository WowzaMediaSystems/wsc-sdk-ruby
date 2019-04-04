####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "transcoder .save", :integration_test => true do
  
  name                    = "auto sdk rtmp pull"
  source_url              = "rtmp://0.0.0.0/live"
  id                      = /\w{8}/
  transcoder_type         = 'transcoded'
  billing_mode            = 'pay_as_you_go'
  protocol                = 'rtmp'
  delivery_method         = 'pull'
  recording               = false
  buffer_size             = 4000
  stream_smoother         = false
  low_latency             = false
  idle_timeout            = 1200
  disable_authentication  = false


  before :all do
    @transcoders      = $client.transcoders
    @data = WscSdk::Templates::Transcoder.rtmp_pull(name, source_url)
    @transcoder = @transcoders.build(@data)
    @response = @transcoder.save
    handle_api_error(@response, "There was an error creating transcoder") unless @response.success?
    @id = @transcoder.id
    @find = @transcoders.find(@id)
    output_model_attributes(@find, "transcoder: #{@find.name}")
  end

  it "had success" do
    expect(@find.success?).to eq(true)
  end
  
  it "has expected id" do
    expect(@find.id).to eq(@id)
  end

  it "has expected name" do
    expect(@find.name).to eq(name)
  end

  it "has expected source_url" do
    expect(@find.source_url).to eq(source_url)
  end

  after :all do
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
