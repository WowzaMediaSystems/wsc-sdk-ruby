####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate the valid types of closed caption interpretation for a Transcoder.
    #
    module ClosedCaptionType
      extend WscSdk::Enums

      # No closed captioning.
      NONE    = "none"

      # Generate CEA closed captioning.
      CEA     = "cea"

      # Generate On Text closed captioning.
      ON_TEXT = "on_text"

      # Generate both types of closed captioning.
      BOTH    = "both"

    end
  end
end
