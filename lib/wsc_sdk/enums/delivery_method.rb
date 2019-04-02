module WscSdk
  module Enums

    # Enumerate the delivery methods for a Transcoder or Live Stream
    #
    module DeliveryMethod
      extend WscSdk::Enums

      # Push content to the Transcoder or Live Stream.
      PUSH    = "push"

      # Pull content into the Transcoder or Live Stream.
      PULL    = "pull"

    end
  end
end
