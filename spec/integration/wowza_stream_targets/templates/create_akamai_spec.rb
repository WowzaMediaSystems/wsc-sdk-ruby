require 'integration/spec_helper'

describe "wowza_stream_target .save akamai", :integration_test => true do
  
  name                    = "auto sdk save akamai"
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
  
  it "had success" do
    expect(@wowza_stream_target.success?).to eq(true)
  end

  it "has expected name" do
    expect(@wowza_stream_target.name).to eq(name)
  end

  it "has expected location" do
    expect(@wowza_stream_target.location).to eq(location)
  end

  it "has expected provider" do
    expect(@wowza_stream_target.provider).to eq(provider)
  end

  it "has expected username" do
    expect(@wowza_stream_target.username).to match(username)
  end

  it "has expected password" do
    expect(@wowza_stream_target.password).to match(password)
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
