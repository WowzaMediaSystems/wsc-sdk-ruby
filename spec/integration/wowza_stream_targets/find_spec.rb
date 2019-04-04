####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "wowza_stream_target .find", :integration_test => true do
  
  name                    = "auto sdk find"
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
    @find = @wowza_stream_targets.find(@id)
    output_model_attributes(@find, "wowza_stream_target: #{@find.name}")
  end
  
  it "had success" do
    expect(@find.success?).to eq(true)
  end

  it "has expected name" do
    expect(@find.name).to eq(name)
  end

  it "has expected location" do
    expect(@find.location).to eq(location)
  end

  it "has expected provider" do
    expect(@find.provider).to eq(provider)
  end

  it "has expected username" do
    expect(@find.username).to match(username)
  end

  it "has expected password" do
    expect(@find.password).to match(password)
  end

  it "has expected primary_url" do
    expect(@find.primary_url).to match(primary_url)
  end

  it "has expected backup_url" do
    expect(@find.backup_url).to match(backup_url)
  end

  it "has expected connection_code" do
    expect(@find.connection_code).to match(connection_code)
  end

  after :all do
    @response = @wowza_stream_targets.delete(@wowza_stream_target)
    handle_api_error(@response, "There was an error deleting wowza_stream_target") unless @response.success?
  end

end
