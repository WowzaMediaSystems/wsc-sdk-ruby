####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate the delivery methods for a Transcoder or Live Stream
    #
    module Encoder
      extend WscSdk::Enums

      # WSE Encoder
      WOWZA_STREAMING_ENGINE = "wowza_streaming_engine"

      # Wowza GoCoder Encoder
      WOWZA_GOCODER          = "wowza_gocoder"

      # Media DS Encoder
      MEDIA_DS               = "media_ds"

      # Axis Encoder
      AXIS                   = "axis"

      # Epiphan Encoder
      EPIPHAN                = "epiphan"

      # Hauppauge Encoder
      HAUPPAUGE              = "hauppauge"

      # JVC Encoder
      JVC                    = "jvc"

      # Live-U Encoder
      LIVE_U                 = "live_u"

      # Matrox Encoder
      MATROX                 = "matrox"

      # NewTek Tricaster Encoder
      NEWTEK_TRICASTER       = "newtek_tricaster"

      # Osprey Encoder
      OSPREY                 = "osprey"

      # Sony Encoder
      SONY                   = "sony"

      # Telestream Wirecast Encoder
      TELESTREAM_WIRECAST    = "telestream_wirecast"

      # Teradek Cube Encoder
      TERADEK_CUBE           = "teradek_cube"

      # VMix Encoder
      VMIX                   = "vmix"

      # X Split Encoder
      X_SPLIT                = "x_split"

      # IP Camera Encoder
      IP_CAMERA              = "ipcamera"

      # Other RTMP Encoder
      OTHER_RTMP             = "other_rtmp"

      # Other RTSP Encoder
      OTHER_RTSP             = "other_rtsp"

    end
  end
end
