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
  
  describe ".delete ull_stream_target" do
    before :all do
      @response = @ull_stream_targets.delete(@ull_stream_target)
      @list = @ull_stream_targets.list
    end

    it ".delete had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "deleted live stream has been deleted as expected" do
      expect(@list.has_key?(@id)).to eq(false)
    end
    
  end
  
  after :all do
    handle_api_error(@response, "There was an error deleting ull stream target") unless @response.success?
  end

end
