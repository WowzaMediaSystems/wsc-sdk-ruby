####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/models/output'

module WscSdk
  module Endpoints

    # An endpoint to manage Outputs.
    #
    class Outputs < WscSdk::Endpoint

      model_class WscSdk::Models::Output

    end
  end
end
