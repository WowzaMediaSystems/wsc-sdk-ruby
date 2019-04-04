####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Endpoints

    # An endpoint to manage Wowza Stream Targets
    #
    class WowzaStreamTargets < WscSdk::Endpoint

      model_class WscSdk::Models::WowzaStreamTarget

      #---------------------------------------------------------------------------
      #  ___      _   _
      # | _ \__ _| |_| |_  ___
      # |  _/ _` |  _| ' \(_-<
      # |_| \__,_|\__|_||_/__/
      #
      #---------------------------------------------------------------------------

      # Get the path for the list of models
      #
      # @return [String]
      #   The list path.
      #
      def list_path
        [ parent_path, "wowza" ].compact.join("/")
      end

      # Get the path for an individual model.
      #
      # @param id [Any]
      #   The unique id of the model.
      #
      # @return [String]
      #   The model path.
      #
      def model_path(id)
        [ parent_path, "wowza", id ].compact.join("/")
      end

    end
  end
end
