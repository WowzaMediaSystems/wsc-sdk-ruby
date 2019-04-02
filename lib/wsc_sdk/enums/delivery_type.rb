module WscSdk
  module Enums

    # Enumerate the delivery methods for a Transcoder or Live Stream
    #
    module DeliveryType
      extend WscSdk::Enums

      # Deliver a single-bitrate stream from WSE to the live stream/transcoder
      SINGLE_BITRATE  = "single-bitrate"

      # Deliver a multi-bitrate stream from WSE to the live stream/transcoder
      MULTI_BITRATE   = "multi-bitrate"

    end
  end
end
