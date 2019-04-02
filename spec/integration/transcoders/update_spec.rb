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
    output_model_attributes(@transcoder, "transcoder: #{@transcoder.name}")
  end

  it "initial create had success" do
    expect(@transcoder.success?).to eq(true)
  end
  
  it "has valid id" do
    expect(@transcoder.id).to match(id)
  end

  it "has expected name" do
    expect(@transcoder.name).to eq(name)
  end
  
  describe "update transcoder name" do
    updated_name = "auto sdk rtmp pull CHANGED"
    before :all do
      @transcoder.name = updated_name
      output_model_attributes(@transcoder, "Transcoder: #{@transcoder.name}")
      @response = @transcoders.update(@transcoder)
    end
    
    it ".update had success" do
      expect(@transcoder.success?).to eq(true)
    end
    
    it "has expected updated name" do
      expect(@transcoder.name).to eq(updated_name)
    end
    
  end

  after :all do
    handle_api_error(@response, "There was an error updating transcoder") unless @response.success?
    @response = @transcoders.delete(@transcoder)
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
