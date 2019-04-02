require 'integration/spec_helper'

@transcoder = ''

describe "end_to_end live_stream", :integration_test => true do
  
  name                  = "auto sdk end_to_end transcoder"
  source_url            = "rtsp://198.233.230.205/media/video1"

  thumbnail_url_regex  = /https:\/\/.+cloud\.wowza\.com\/proxy\/thumbnail2/
  
  
  before :all do
    @wowza_stream_targets      = $client.stream_targets.wowza
    @wowza_stream_target = @wowza_stream_targets.build(WscSdk::Templates::WowzaStreamTarget.akamai("auto sdk e2e", "us_west_california"))
    @response = @wowza_stream_target.save
    handle_api_error(@response, "There was an error creating wowza_stream_target") unless @response.success?
    output_model_attributes(@wowza_stream_target, "wowza_stream_target: #{@wowza_stream_target.name}")
    @st_id = @wowza_stream_target.id
    
    @transcoders      = $client.transcoders
    @transcoder = @transcoders.build(WscSdk::Templates::Transcoder.rtsp_pull(name, source_url))
    @response = @transcoder.save
    handle_api_error(@response, "There was an error creating transcoder") unless @response.success?
    output_model_attributes(@transcoder, "transcoder: #{@transcoder.name}")
    
    @outputs = @transcoder.outputs
    @output = @outputs.build(WscSdk::Templates::Output.hd)
    @response = @output.save
    handle_api_error(@response, "There was an error creating output") unless @response.success?
    output_model_attributes(@output, "output: #{@output.name}")
    
    data = {
      stream_target_id: @st_id
    }
    @output_stream_target = @output.output_stream_targets.build(data)
    @response = @output_stream_target.save
    handle_api_error(@response, "There was an error creating output_stream_target") unless @response.success?
    output_model_attributes(@output_stream_target, "output_stream_target:")
  end
  
  describe "create new transcoder" do
    before :all do
      @tr_id = @transcoder.id
      @list = @transcoders.list
    end
    
    it "newly created transcoder is in .list" do
      expect(@list.has_key?(@tr_id)).to eq(true)
    end
    
    describe "get transcoder state before starting" do
      before :all do
        @state = @transcoder.state
        handle_api_error(@state, "There was an error getting state for transcoder") unless @state.success?
        output_model_attributes(@state, "transcoder state:")
      end
      it "transcoder state has expected value of 'stopped'" do
        expect(@state.state).to eq('stopped')
      end
    end
    
    describe "start transcoder" do
      before :all do
        @state = @transcoder.start(:timeout => 240) do |wait_state, transcoder_state|
          if wait_state == :waiting
            output_model_attributes(transcoder_state, "transcoder_state:")
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(transcoder_state, "Completed transcoder_state:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not start the transcoder within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error starting transcoder") unless @state.success?
        @transcoder_state = @transcoder.state
        sleep 30
      end
      
      it "transcoder_state is started" do
        expect(@transcoder_state.state).to eq("started")
      end
      
      describe "get thumbnail_url" do
        before :all do
          @thumbnail_url = @transcoder.thumbnail_url
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
      
      describe "get transcoder stats" do
        before :all do
          @stats = @transcoder.stats
          output_model_attributes(@stats, "@stats:")
          sleep 5
          @stats = @transcoder.stats
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
      
    end
    
    describe "reset transcoder" do
      before :all do
        @state = @transcoder.reset(:timeout => 240) do |wait_state, transcoder_state|
          if wait_state == :waiting
            output_model_attributes(transcoder_state, "transcoder_state:")
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(transcoder_state, "Completed transcoder_state:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not start the transcoder within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error resetting transcoder") unless @state.success?
        @transcoder_state = @transcoder.state
        sleep 30
      end
      
      it "transcoder_state is started" do
        expect(@transcoder_state.state).to eq("started")
      end
      
      describe "get thumbnail_url" do
        before :all do
          @thumbnail_url = @transcoder.thumbnail_url
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
      
      describe "get transcoder stats" do
        before :all do
          @stats = @transcoder.stats
          output_model_attributes(@stats, "@stats:")
          sleep 5
          @stats = @transcoder.stats
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
      
    end
    
    describe "stop transcoder" do
      before :all do
        @state = @transcoder.stop do |wait_state, transcoder_state|
          if wait_state == :waiting
            puts "Waiting..."
          elsif wait_state == :complete
            output_model_attributes(transcoder_state, "Completed transcoder_state:")
          elsif wait_state == :timeout
            puts "TIMEOUT: Could not stop the transcoder within the timeout period."
          end
        end
        handle_api_error(@state, "There was an error stopping transcoder") unless @state.success?
        @transcoder_state = @transcoder.state
      end

      it "transcoder_state is stopped" do
        expect(@transcoder_state.state).to eq("stopped")
      end
    end
    
    describe ".delete the transcoder" do
      before :all do
        @response = @transcoders.delete(@transcoder)
        handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
        @list = @transcoders.list
        handle_api_error(@response, "There was an error deleting transcoder") unless @response.success?
      end
      
      it "should be deleted" do
        expect(@list.has_key?(@id)).to eq(false)
      end
    end

  end
  
  after :all do
  end

end
