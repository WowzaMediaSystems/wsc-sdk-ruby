####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "custom_stream_target .save rtmp", :integration_test => true do
  
  name                    = "auto sdk save rtmp"
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
  
  it "has expected name" do
    expect(@custom_stream_target.name).to eq(name)
  end

  it "has expected provider" do
    expect(@custom_stream_target.provider).to eq(provider)
  end
  
  it "has expected stream_name" do
    expect(@custom_stream_target.stream_name).to eq(stream_name)
  end

  it "has expected primary_url" do
    expect(@custom_stream_target.primary_url).to eq(primary_url)
  end

  after :all do
    @response = @custom_stream_targets.delete(@custom_stream_target)
    handle_api_error(@response, "There was an error deleting custom_stream_target") unless @response.success?
  end

end
