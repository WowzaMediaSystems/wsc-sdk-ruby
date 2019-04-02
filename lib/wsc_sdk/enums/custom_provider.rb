module WscSdk
  module Enums

    # Enumerate valid transcoder types.
    #
    module CustomProvider
      extend WscSdk::Enums

      # Akamai Custom Provider
      AKAMAI_HD     = "akamai"

      # Akamai Cupertino Custom Provider
      AKAMAI_HLS    = "akamai_cupertino"

      # Akamai RTMP Custom Provider
      AKAMAI_RTMP    = "akamai_rtmp"

      # Limelight Custom Provider
      LIMELIGHT     = "limelight"

      # RTMP Custom Provider
      RTMP          = "rtmp"

      # UStream Custom Provider
      USTREAM       = "ustream"

    end
  end
end
