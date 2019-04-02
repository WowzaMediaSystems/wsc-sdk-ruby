require 'wsc_sdk/model'
require 'wsc_sdk/models/transcoder_state'

module WscSdk
  module Models

    # A model to represent the State of a Live Stream in the Wowza Streaming
    # Cloud API.
    #
    class LiveStreamState < TranscoderState

      model_name_singular :live_stream
      model_name_plural   :live_streams

    end
  end
end
