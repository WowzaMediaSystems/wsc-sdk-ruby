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
