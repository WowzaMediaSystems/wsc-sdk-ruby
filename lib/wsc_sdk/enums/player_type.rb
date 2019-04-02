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
