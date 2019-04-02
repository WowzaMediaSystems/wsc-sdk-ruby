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
