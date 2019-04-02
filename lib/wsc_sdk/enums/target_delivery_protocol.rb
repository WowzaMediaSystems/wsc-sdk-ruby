module WscSdk
  module Enums

    # Enumerate the delivery methods for a Transcoder or Live Stream
    #
    module TargetDeliveryProtocol
      extend WscSdk::Enums

      # Push content to the Transcoder or Live Stream.
      HLS_HTTPS           = "hls-https"

      # Pull content into the Transcoder or Live Stream.
      HLS_HDS             = "hls-hds"

    end
  end
end
