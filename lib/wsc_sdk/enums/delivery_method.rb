####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

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
