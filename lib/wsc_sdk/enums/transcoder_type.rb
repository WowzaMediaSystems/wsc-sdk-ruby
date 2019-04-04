####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate valid transcoder types.
    #
    module TranscoderType
      extend WscSdk::Enums

      # A transcoded stream type
      TRANSCODED    = "transcoded"

      # A passthrough stream type
      PASSTHROUGH   = "passthrough"

    end
  end
end
