####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Enums

    # Enumerate valid idle timeouts for a Transcoder.
    #
    module IdleTimeout
      extend WscSdk::Enums

      # No idle timeout.  The transcoder will run without stopping automatically
      NONE            = 0

      # Timeout after 1 minute of inactivity from the source.
      ONE_MINUTE      = 1

      # Timeout after 10 minutes of inactivity from the source.
      TEN_MINUTES     = 600

      # Timeout after 20 minutes of inactivity from the source.
      TWENTY_MINUTES  = 1200

      # Timeout after 30 minutes of inactivity from the source.
      THIRTY_MINUTES  = 1800

      # Timeout after 1 hour of inactivity from the source.
      ONE_HOUR        = 3600

      # Timeout after 6 hours of inactivity from the source.
      SIX_HOURS       = 21600

      # Timeout after 12 hours of inactivity from the source.
      TWELVE_HOURS    = 43200

      # Timeout after 1 day of inactivity from the source.
      ONE_DAY         = 86400

      # Timeout after 2 days of inactivity from the source.
      TWO_DAYS        = 172800

      # Return the valid range of values for the idle timeout.
      #
      def self.values
        (NONE..TWO_DAYS)
      end

    end
  end
end
