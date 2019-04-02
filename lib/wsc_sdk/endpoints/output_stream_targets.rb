require 'wsc_sdk/models/output'

module WscSdk
  module Endpoints

    # An endpoint to manage Output Stream Targets.
    #
    class OutputStreamTargets < WscSdk::Endpoint

      model_class WscSdk::Models::OutputStreamTarget

    end
  end
end
