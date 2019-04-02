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
