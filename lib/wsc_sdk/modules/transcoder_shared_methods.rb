####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # Module for providing methods to handle state actions and transitions for a
  # Transcoder or Live Stream model, since they have a lot of shared
  # functionality.
  #
  module TranscoderSharedMethods

    #---------------------------------------------------------------------------
    #    _      _   _
    #   /_\  __| |_(_)___ _ _  ___
    #  / _ \/ _|  _| / _ \ ' \(_-<
    # /_/ \_\__|\__|_\___/_||_/__/
    #
    #---------------------------------------------------------------------------


    # Start the transcoder/live stream
    #
    # If a block is passed to the call, the SDK will start a state request
    # loop that checks the state of the transcoder for a given period of time
    # (timeout). Each iteration of the wait loop will call the block with the
    # current state of the wait loop, and the current state of the
    # transcoder
    #
    # The wait state will be one of 3 options: :waiting, :complete or :timeout
    #
    # The loop will exit when the transcoder state is "started" or the timeout
    # limit is reached.
    #
    # @param options [Hash] A hash of options
    #
    # @option options [Integer] :timeout (30) The maximum wait for a `started` state response.
    # @option options [Integer] :poll_interval (5) The wait time (in seconds) between state requests.  (Min: 1)
    #
    # @return [WscSdk::Model::TranscoderState] The transcoder state after the method execution has completed.
    #
    # @yield [wait_state, transcoder_state] Calls the block with  the states of the wait loop and the transcoder.
    # @yieldparam wait_state [Symbol] The current state of the wait loop.  Will always be one of the following: :waiting, :complete, :cannot_change_state or :timeout
    # @yieldparam transcoder_state [WscSdk::Model::TranscoderState] The current transcoder state data.
    #
    # @example Simple Start Request
    #   state = transcoder.start
    #
    # @example Start and Wait for Started
    #   transcoder.start do |wait_state, transcoder_state|
    #     if wait_state == :waiting
    #       puts "Waiting for the transcoder to start..."
    #     if wait_state == :timeout
    #       puts "The transcoder did not start in within the timeout period."
    #     else
    #       puts "Transcoder is #{state.state}.  The IP Address is #{state.ip_address}."
    #     end
    #   end
    #
    def start(options={}, &block)
      current_state = self.endpoint.start(self.id)
      return wait_for_state(:started, options, &block) if current_state.success? and block_given?
      return current_state
    end

    # Stop the transcoder
    #
    # If a block is passed to the call, the SDK will start a state request
    # loop that checks the state of the transcoder for a given period of time
    # (timeout). Each iteration of the wait loop will call the block with the
    # current state of the wait loop, and the current state of the
    # transcoder
    #
    # The wait state will be one of 3 options: :waiting, :complete or :timeout
    #
    # The loop will exit when the transcoder state is "stopped" or the timeout
    # limit is reached.
    #
    # @param options [Hash] A hash of options
    #
    # @option options [Integer] :timeout (30) The maximum wait for a `stopped` state response.
    # @option options [Integer] :poll_interval (5) The wait time (in seconds) between state requests.  (Min: 1)
    #
    # @return [WscSdk::Model::TranscoderState] The transcoder state after the method execution has completed.
    #
    # @yield [wait_state, transcoder_state] Calls the block with the states of the wait loop and the transcoder.
    # @yieldparam wait_state [Symbol] The current state of the wait loop.  Will always be one of the following: :waiting, :complete, :cannot_change_state or :timeout
    # @yieldparam transcoder_state [WscSdk::Model::TranscoderState] The current transcoder state data.
    #
    # @example Simple Stop Request
    #   state = transcoder.stop
    #
    # @example Stop and Wait for Stopped
    #   transcoder.stop do |wait_state, transcoder_state|
    #     if wait_state == :waiting
    #       puts "Waiting for the transcoder to stop..."
    #     if wait_state == :timeout
    #       puts "The transcoder did not stop in within the timeout period."
    #     else
    #       puts "Transcoder is #{state.state}."
    #     end
    #   end
    #
    def stop(options={}, &block)
      current_state = self.endpoint.stop(self.id)
      return wait_for_state(:stopped, options, &block) if current_state.success? and block_given?
      return current_state
    end

    # Reset the transcoder/live stream
    #
    # If a block is passed to the call, the SDK will start a state request
    # loop that checks the state of the transcoder for a given period of time
    # (timeout). Each iteration of the wait loop will call the block with the
    # current state of the wait loop, and the current state of the
    # transcoder
    #
    # The wait state will be one of 3 options: :waiting, :complete or :timeout
    #
    # The loop will exit when the transcoder state is "started" or the timeout
    # limit is reached.
    #
    # @param options [Hash] A hash of options
    #
    # @option options [Integer] :timeout (30) The maximum wait for a `started` state response.
    # @option options [Integer] :poll_interval (5) The wait time (in seconds) between state requests.  (Min: 1)
    #
    # @return [WscSdk::Model::TranscoderState] The transcoder state after the method execution has completed.
    #
    # @yield [wait_state, transcoder_state] Calls the block with  the states of the wait loop and the transcoder.
    # @yieldparam wait_state [Symbol] The current state of the wait loop.  Will always be one of the following: :waiting, :complete, :cannot_change_state or :timeout
    # @yieldparam transcoder_state [WscSdk::Model::TranscoderState] The current transcoder state data.
    #
    # @example Simple Reset Request
    #   state = transcoder.reset
    #
    # @example Reset and Wait for Started
    #   transcoder.reset do |wait_state, transcoder_state|
    #     if wait_state == :waiting
    #       puts "Waiting for the transcoder to start..."
    #     if wait_state == :timeout
    #       puts "The transcoder did not start in within the timeout period."
    #     else
    #       puts "Transcoder is #{state.state}.  The IP Address is #{state.ip_address}."
    #     end
    #   end
    #
    def reset(options={}, &block)
      current_state = self.endpoint.reset(self.id)
      return wait_for_state(:started, options, &block) if current_state.success? and block_given?
      return current_state
    end

    # Return the current state of the transcoder/live stream.
    #
    # @return [WscSdk::Model::TranscoderState]
    #
    def state
      return self.endpoint.state(self.id)
    end


    # Return the url of the current thumbnail for transcoder/live stream.
    #
    # @return [WscSdk::Model::TranscoderThumbnailUrl]
    #
    def thumbnail_url
      return self.endpoint.thumbnail_url(self.id)
    end

    # Return the url of the current stats for the transcoder/live stream.
    #
    # @return [WscSdk::Model::TranscoderStats]
    #
    def stats
      return self.endpoint.stats(self.id)
    end

    # Wait for a given state to be returned from the API.
    #
    # @param state [Symbol] The name of the state we are expecting to be returned.
    # @param options [Hash] A hash of options
    #
    # @option options [Integer] :timeout (120) The maximum wait (in seconds) for a `started` state response.
    # @option options [Integer] :poll_interval (5) The wait time (in seconds) between state requests.  (Min: 1)
    #
    # @return [Array<Symbol, WscSdk::Model::TranscoderState>] The `state` of the transcoder when the request is made or when the state request loop is complete.
    #
    # @yield [wait_state, state] Returns the state of the waiting loop and the state of the of the transcoder when the transcoder has started, or the timeout has been reached.
    # @yieldparam result [Symbol] The result of waiting for the transcoder start.  Returns either the current state of the transcoder, or :timeout if the wait timout was reached.
    # @yieldparam state [WscSdk::Model::TranscoderState] The last transcoder state data before the start wait cycle was completed.
    #
    private def wait_for_state(state, options={}, block=Proc.new)
      state             = state.to_sym
      first             = true
      timeout           = options.fetch(:timeout, 120)
      poll_interval     = [options.fetch(:poll_interval, 5).to_i, 1].max
      start             = Time.now
      elapsed           = 0
      wait_state        = :waiting
      current_state     = nil

      while((elapsed < timeout) and (wait_state == :waiting))
        sleep(poll_interval) unless first # Don't sleep on the first iteration.
        first           = false
        current_state   = self.state
        elapsed         = Time.now - start
        wait_state      = :timeout if elapsed >= timeout

        if current_state.success?
          wait_state    = :complete if current_state.state.to_sym == state.to_sym
        else
          wait_state    = :cannot_change_state
        end
        block.call(wait_state, current_state)
      end
      result ||= :timeout
      return current_state
    end

  end
end
