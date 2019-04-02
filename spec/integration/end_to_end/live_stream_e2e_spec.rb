require 'integration/spec_helper'

describe "end_to_end live_stream", :integration_test => true do
  
  name                  = "auto sdk end_to_end live_stream"
  aspect_ratio_width    = 1280
  aspect_ratio_height   = 720
  source_url            = "198.233.230.205/media/video1"
  protocol              = "rtsp"
  delivery_method       = "pull"
  thumbnail_url_regex  = /https:\/\/.+cloud\.wowza\.com\/proxy\/thumbnail2/
  
  @live_streams         = nil
  @live_stream          = nil
  @ls_id                = nil
  
  describe "create new live_stream" do
    before :all do
      @live_streams  = $client.live_streams
      ls_data = WscSdk::Templates::LiveStream.rtsp_pull(name, aspect_ratio_width, aspect_ratio_height, source_url)
      @live_stream = @live_streams.build(ls_data)
      @response = @live_stream.save
      handle_api_error(@response, "There was an error creating live streams") unless @response.success?
      output_model_attributes(@live_stream, "Live Stream: #{@live_stream.name}")
      @ls_id = @live_stream.id
      @list = @live_streams.list
    end
    
    it "had success with .save" do
      expect(@response.success?).to eq(true)
    end
  
    it "newly created live stream is in .list" do
      expect(@list.has_key?(@ls_id)).to eq(true)
    end
    
    describe "get live_stream state before starting" do
      before :all do
        @state = @live_stream.state
        handle_api_error(@state, "There was an error getting state for live_stream") unless @state.success?
        output_model_attributes(@state, "Live Stream state:")
      end
      it "live_stream_state has expected value of 'stopped'" do
        expect(@state.state).to eq('stopped')
      end
    end
    
    describe "start Live Stream" do
      before :all do
        @state = @live_stream.start(:timeout => 240) do |wait_state, live_stream_state|
          if wait_state == :waiting
            output_model_attributes(live_stream_state, "Live Stream State:")
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(live_stream_state, "Completed Live Stream State:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not start the live stream within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error starting live stream") unless @state.success?
        @live_stream_state = @live_stream.state
        sleep 30
      end
      
      it "live_stream_state is started" do
        expect(@live_stream_state.state).to eq("started")
      end
      
      describe "get live_stream stats" do
        before :all do
          @stats = @live_stream.stats
          output_model_attributes(@stats, "@stats:")
          sleep 5
          @stats = @live_stream.stats
          output_model_attributes(@stats, "@stats:")
        end
        it "has bytes_in_rate" do
          expect(@stats.bytes_in_rate.value).to be > 0
        end
        it "has valid cpu value" do
          expect(@stats.cpu.value).to be_between(1,100)
        end
        it "has frame_rate value" do
          expect(@stats.frame_rate.value).to be_between(5,61)
        end
      end
      
      describe "get thumbnail_url" do
        before :all do
          @thumbnail_url = @live_stream.thumbnail_url
          output_model_attributes(@thumbnail_url, "@thumbnail_url:")
          thumb_get = HTTParty.get(@thumbnail_url.thumbnail_url)
          @hexstring = ''
          thumb_get.response.body[0,4].each_byte.map { |b| @hexstring.concat(b.to_s(16)) }
          # puts "@hexstring=#{@hexstring}"
        end
        
        it ".thumbnail_url looks like a url" do
          expect(@thumbnail_url.thumbnail_url).to match(thumbnail_url_regex)
        end
        
        it "thumbnail is a jpg" do
          expect(@hexstring).to eq("ffd8ffe0")
        end
      end
      
    end
    
    describe "reset Live Stream" do
      before :all do
        @state = @live_stream.reset(:timeout => 240) do |wait_state, live_stream_state|
          if wait_state == :waiting
            output_model_attributes(live_stream_state, "Live Stream State:")
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(live_stream_state, "Completed Live Stream State:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not reset the live stream within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error resetting live stream") unless @state.success?
        @live_stream_state = @live_stream.state
        sleep 30
      end
      
      it "live_stream_state is started" do
        expect(@live_stream_state.state).to eq("started")
      end
      
      describe "get live_stream stats" do
        before :all do
          @stats = @live_stream.stats
          output_model_attributes(@stats, "@stats:")
          sleep 5
          @stats = @live_stream.stats
          output_model_attributes(@stats, "@stats:")
        end
        it "has bytes_in_rate" do
          expect(@stats.bytes_in_rate.value).to be > 0
        end
        it "has valid cpu value" do
          expect(@stats.cpu.value).to be_between(1,100)
        end
        it "has frame_rate value" do
          expect(@stats.frame_rate.value).to be_between(5,61)
        end
      end
      
      describe "get thumbnail_url" do
        before :all do
          @thumbnail_url = @live_stream.thumbnail_url
          output_model_attributes(@thumbnail_url, "@thumbnail_url:")
          thumb_get = HTTParty.get(@thumbnail_url.thumbnail_url)
          @hexstring = ''
          thumb_get.response.body[0,4].each_byte.map { |b| @hexstring.concat(b.to_s(16)) }
          # puts "@hexstring=#{@hexstring}"
        end
        
        it ".thumbnail_url looks like a url" do
          expect(@thumbnail_url.thumbnail_url).to match(thumbnail_url_regex)
        end
        
        it "thumbnail is a jpg" do
          expect(@hexstring).to eq("ffd8ffe0")
        end
      end
      
    end
    describe "stop Live Stream" do
      before :all do
        @state = @live_stream.stop do |wait_state, live_stream_state|
          if wait_state == :waiting
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(live_stream_state, "Completed Live Stream State:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not stop the live stream within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error stopping live stream") unless @state.success?
        @live_stream_state = @live_stream.state
      end

      it "live_stream_state is stopped" do
        expect(@live_stream_state.state).to eq("stopped")
      end
    end
    
    describe ".delete the live_stream" do
      before :all do
        @response = @live_streams.delete(@live_stream)
        handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
        @list = @live_streams.list
        handle_api_error(@response, "There was an error deleting live streams") unless @response.success?
      end
      
      it "should be deleted" do
        expect(@list.has_key?(@id)).to eq(false)
      end
    end

  end
  
  after :all do
  end

end
