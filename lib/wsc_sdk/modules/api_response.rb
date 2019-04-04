####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # Module that adds common functionality for an API response object.
  #
  module ApiResponse

    # Determine if the response was a result of a successful API call.
    #
    # @return [Boolean]
    #   An indication of the success of the call.
    #
    def success?
      if @success.nil?
        @success = true
      end

      @success
    end

  end
end
