####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'integration/spec_helper'

describe "ull_stream_target .save", :integration_test => true do
  
  name          = "auto sdk save"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtmp://0.0.0.0/live"
  source_delivery_method = "pull"
  enabled       = true
  playback_urls_regex   = /(ws:|wss:|wowz:|wowzs:)\/\/(edge-qa|edge)\.cdn\.wowza\.com\/live\/_definst_\//

  before :all do
    @ull_stream_targets      = $client.stream_targets.ull
    data = WscSdk::Templates::UllStreamTarget.pull(name, source_url)
    @ull_stream_target = @ull_stream_targets.build(data)
    @response = @ull_stream_target.save
    handle_api_error(@response, "There was an error creating ull_stream_target") unless @response.success?
    output_model_attributes(@ull_stream_target, "ull_stream_target: #{@ull_stream_target.name}")
    @id = @ull_stream_target.id
    @list = @ull_stream_targets.list
  end
  
  it "newly created ull_stream_target is in .list" do
    expect(@list.has_key?(@id)).to eq(true)
  end
  
  it "had success" do
    expect(@ull_stream_target.success?).to eq(true)
  end

  it "has expected name" do
    expect(@ull_stream_target.name).to eq(name)
  end

  it "has expected source_url" do
    expect(@ull_stream_target.source_url).to eq(source_url)
  end

  it "has expected enabled" do
    expect(@ull_stream_target.enabled).to eq(enabled)
  end

  it "has expected source_delivery_method" do
    expect(@ull_stream_target.source_delivery_method).to eq(source_delivery_method)
  end

  it "has expected wowz playback_urls" do
    expect(@ull_stream_target.playback_urls[:wowz][0]).to match(playback_urls_regex)
    expect(@ull_stream_target.playback_urls[:wowz][1]).to match(playback_urls_regex)
  end

  it "has expected ws playback_urls" do
    expect(@ull_stream_target.playback_urls[:ws][0]).to match(playback_urls_regex)
    expect(@ull_stream_target.playback_urls[:ws][1]).to match(playback_urls_regex)
  end

  after :all do
    @response = @ull_stream_targets.delete(@ull_stream_target)
    handle_api_error(@response, "There was an error deleting ull stream target") unless @response.success?
  end

end
