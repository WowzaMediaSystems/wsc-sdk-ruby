####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate common buffer sizes within the appropriate range for a Transcoder.
    #
    module BufferSize
      extend WscSdk::Enums

      # Define no buffer.
      NONE              = 0

      # Define a 1 second buffer
      ONE_SECOND        = 1000

      # Define a 2 second buffer
      TWO_SECONDS       = 2000

      # Define a 3 second buffer
      THREE_SECONDS     = 3000

      # Define a 4 second buffer
      FOUR_SECONDS      = 4000

      # Define a 5 second buffer
      FIVE_SECONDS      = 5000

      # Define a 6 second buffer
      SIX_SECONDS       = 6000

      # Define a 7 second buffer
      SEVEN_SECONDS     = 7000

      # Define a 8 second buffer
      EIGHT_SECONDS     = 8000

    end
  end
end
