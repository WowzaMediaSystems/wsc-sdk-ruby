require 'integration/spec_helper'

describe "wowza_stream_target .delete", :integration_test => true do
  
  name                    = "auto sdk delete"
  location                = "us_west_california"
  provider                = "akamai"
  username                = /\d{6}/
  password                = /\w{10}/
  primary_url             = /rtmp:\/\/p\..+\.akamaientrypoint\.net\/EntryPoint/
  backup_url              = /rtmp:\/\/b\..+\.akamaientrypoint\.net\/EntryPoint/
  connection_code         = /\w{6}/

  before :all do
    @wowza_stream_targets      = $client.stream_targets.wowza
    data = WscSdk::Templates::WowzaStreamTarget.akamai(name, location)
    @wowza_stream_target = @wowza_stream_targets.build(data)
    @response = @wowza_stream_target.save
    handle_api_error(@response, "There was an error creating wowza_stream_target") unless @response.success?
    output_model_attributes(@wowza_stream_target, "wowza_stream_target: #{@wowza_stream_target.name}")
    @id = @wowza_stream_target.id
    @list = @wowza_stream_targets.list
  end
  
  it "newly created wowza_stream_target is in .list" do
    expect(@list.has_key?(@id)).to eq(true)
  end
  
  describe ".delete transcoder" do
    before :all do
      @response = @wowza_stream_targets.delete(@wowza_stream_target)
      @list = @wowza_stream_targets.list
    end
    
    it ".delete had success" do
      expect(@response.success?).to eq(true)
    end
  
    it "deleted wowza_stream_target has been deleted as expected" do
      expect(@list.has_key?(@id)).to eq(false)
    end
    
  end
  
  after :all do
    handle_api_error(@response, "There was an error deleting wowza_stream_target") unless @response.success?
  end

end
