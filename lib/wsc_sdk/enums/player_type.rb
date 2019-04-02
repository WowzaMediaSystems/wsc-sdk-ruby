####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate the delivery methods for a Transcoder or Live Stream
    #
    module PlayerType
      extend WscSdk::Enums

      # Original HTML5 Player
      ORIGINAL_HTML5  = "original_html5"

      # Wowza Player
      WOWZA           = "wowza_player"
      
    end
  end
end
