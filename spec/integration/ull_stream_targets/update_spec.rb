require 'integration/spec_helper'

describe "ull_stream_target .update ", :integration_test => true do
  
  name          = "auto sdk update"
  aspect_ratio_width         = 1920
  aspect_ratio_height        = 1080
  source_url    = "rtmp://0.0.0.0/live"
  protocol      = "rtmp"
  delivery_method = "pull"

  before :all do
    @ull_stream_targets      = $client.stream_targets.ull
    data = WscSdk::Templates::UllStreamTarget.pull(name, source_url)
    @ull_stream_target = @ull_stream_targets.build(data)
    @response = @ull_stream_target.save
    handle_api_error(@response, "There was an error creating live streams") unless @response.success?
    output_model_attributes(@ull_stream_target, "ull_stream_target: #{@ull_stream_target.name}")
  end
  
  it "initial create had success" do
    expect(@response.success?).to eq(true)
  end

  it "has initial expected name" do
    expect(@ull_stream_target.name).to eq(name)
  end
  
  describe "update ull_stream_target name" do
    updated_name = "auto sdk CHANGED"
    before :all do
      @ull_stream_target.name = updated_name
      output_model_attributes(@ull_stream_target, "ull_stream_target: #{@ull_stream_target.name}")
      @response = @ull_stream_targets.update(@ull_stream_target)
    end
    
    it "update had success" do
      expect(@response.success?).to eq(true)
    end
    
    it "has expected updated name" do
      expect(@ull_stream_target.name).to eq(updated_name)
    end
  end

  after :all do
    handle_api_error(@response, "There was an error updating ull_stream_target") unless @response.success?
    @response = @ull_stream_targets.delete(@ull_stream_target)
    handle_api_error(@response, "There was an error deleting ull_stream_target") unless @response.success?
  end

end
