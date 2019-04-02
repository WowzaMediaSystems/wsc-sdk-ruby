require 'integration/spec_helper'

describe "custom_stream_target .update", :integration_test => true do
  
  name                    = "auto sdk update"
  primary_url             = "rtmp://10.0.0.1/live"
  stream_name             = "auto_stream_name"
  location                = "us_west_california"
  provider                = "rtmp"
  id                      = /\w{8}/

  before :all do
    @custom_stream_targets      = $client.stream_targets.custom
    data = WscSdk::Templates::CustomStreamTarget.rtmp(name, primary_url, stream_name)
    @custom_stream_target = @custom_stream_targets.build(data)
    @response = @custom_stream_target.save
    handle_api_error(@response, "There was an error creating custom_stream_target") unless @response.success?
    output_model_attributes(@custom_stream_target, "custom_stream_target: #{@custom_stream_target.name}")
    @id = @custom_stream_target.id
    @list = @custom_stream_targets.list
  end
  
  it "newly created custom_stream_target is in .list" do
    expect(@list.has_key?(@id)).to eq(true)
  end
  
  it "had success" do
    expect(@custom_stream_target.success?).to eq(true)
  end

  it "has valid id" do
    expect(@custom_stream_target.id).to match(id)
  end
  
  it "has expected initial name" do
    expect(@custom_stream_target.name).to eq(name)
  end

  describe "update custom_stream_target name" do
    updated_name = "auto sdk CHANGED"
    before :all do
      @custom_stream_target.name = updated_name
      output_model_attributes(@custom_stream_target, "custom_stream_target: #{@custom_stream_target.name}")
      @response = @custom_stream_targets.update(@custom_stream_target)
    end
    
    it "update had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "has expected updated name" do
      expect(@custom_stream_target.name).to eq(updated_name)
    end
  end

  after :all do
    @response = @custom_stream_targets.delete(@custom_stream_target)
    handle_api_error(@response, "There was an error deleting custom_stream_target") unless @response.success?
  end

end
