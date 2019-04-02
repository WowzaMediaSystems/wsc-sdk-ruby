####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate valid transcoder types.
    #
    module ImagePosition
      extend WscSdk::Enums

      # Position watermark in the top left corner of the stream
      TOP_LEFT      = "top-left"

      # Position watermark in the top right corner of the stream
      TOP_RIGHT     = "top-right"

      # Position watermark in the bottom left corner of the stream
      BOTTOM_LEFT   = "bottom-left"

      # Position watermark in the bottom left corner of the stream
      BOTTOM_RIGHT  = "bottom-right"

    end
  end
end
