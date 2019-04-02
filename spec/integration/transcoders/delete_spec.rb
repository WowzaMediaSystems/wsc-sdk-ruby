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

  before :all do
    @transcoders      = $client.transcoders
    @data = WscSdk::Templates::Transcoder.rtmp_pull(name, source_url)
    @transcoder = @transcoders.build(@data)
    @response = @transcoder.save
    handle_api_error(@response, "There was an error creating transcoder") unless @response.success?
    output_model_attributes(@transcoder, "transcoder: #{@transcoder.name}")
    @id = @transcoder.id
    @list = @transcoders.list
  end

  it "newly created transcoder is in .list" do
    expect(@list.has_key?(@id)).to eq(true)
  end
  
  describe ".delete transcoder" do
    before :all do
      @response = @transcoders.delete(@transcoder)
      @list = @transcoders.list
    end

    it ".delete had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "deleted transcoder has been deleted as expected" do
      expect(@list.has_key?(@id)).to eq(false)
    end
    
  end

  after :all do
    handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
  end


end
