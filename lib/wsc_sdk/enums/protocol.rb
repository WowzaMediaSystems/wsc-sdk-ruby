####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate valid protocols for a Transcoder or Live Stream.
    #
    module Protocol
      extend WscSdk::Enums

      # The RTMP protocol.
      RTMP    = "rtmp"

      # The RTSP protocol.
      RTSP    = "rtsp"

      # The Wowza protocol (used for ULL)
      WOWZ    = "wowz"

    end
  end
end
