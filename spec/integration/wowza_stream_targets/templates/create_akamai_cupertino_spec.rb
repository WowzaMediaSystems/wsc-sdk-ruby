####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "wowza_stream_target .save akamai_cupertino", :integration_test => true do
  
  name                    = "auto sdk save akamai_cupertino"
  use_secure_ingest       = true
  use_cors                = false
  location                = nil
  provider                = "akamai_cupertino"
  username                = nil
  password                = nil
  primary_url             = /http:\/\/post\.wowzaqainjest.+\.akamaihd\.net\/.+/
  backup_url              = nil
  connection_code         = /\w{6}/

  before :all do
    @wowza_stream_targets      = $client.stream_targets.wowza
    data = WscSdk::Templates::WowzaStreamTarget.akamai_cupertino(name, use_secure_ingest, use_cors)
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
  
  it "had success" do
    expect(@wowza_stream_target.success?).to eq(true)
  end

  it "has expected name" do
    expect(@wowza_stream_target.name).to eq(name)
  end

  it "has expected provider" do
    expect(@wowza_stream_target.provider).to eq(provider)
  end

  it "has expected location of nil" do
    expect(@wowza_stream_target.location).to eq(location)
  end

  it "has expected use_secure_ingest" do
    expect(@wowza_stream_target.use_secure_ingest).to eq(use_secure_ingest)
  end

  it "has expected use_cors" do
    expect(@wowza_stream_target.use_cors).to eq(use_cors)
  end

  it "has expected username" do
    expect(@wowza_stream_target.username).to eq(username)
  end

  it "has expected password" do
    expect(@wowza_stream_target.password).to eq(password)
  end

  it "has expected primary_url" do
    expect(@wowza_stream_target.primary_url).to match(primary_url)
  end

  it "has expected backup_url" do
    expect(@wowza_stream_target.backup_url).to match(backup_url)
  end

  it "has expected connection_code" do
    expect(@wowza_stream_target.connection_code).to match(connection_code)
  end

  after :all do
    @response = @wowza_stream_targets.delete(@wowza_stream_target)
    handle_api_error(@response, "There was an error deleting wowza_stream_target") unless @response.success?
  end

end
