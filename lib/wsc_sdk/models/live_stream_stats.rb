require 'wsc_sdk/model'
require 'wsc_sdk/models/transcoder_stats'

module WscSdk
  module Models

    # A model to represent the Stats of a Live Stream in the Wowza Streaming
    # Cloud API.
    #
    class LiveStreamStats < TranscoderStats

      model_name_singular :live_stream
      model_name_plural   :live_streams

    end
  end
end
