module WscSdk
  module Enums

    # Enumerates the billing modes for a Transcoder or Live Stream.
    #
    module BillingMode
      extend WscSdk::Enums

      # Define a Pay-as-you-go transcoder
      PAY_AS_YOU_GO     = "pay_as_you_go"

      # Define a 24x7 transcoder
      TWENTY_FOUR_SEVEN = "twentyfour_seven"

    end
  end
end
