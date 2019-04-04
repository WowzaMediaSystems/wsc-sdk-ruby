####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Endpoints

    # An endpoint to manage Custom Stream Targets
    #
    class CustomStreamTargets < WscSdk::Endpoint

      model_class WscSdk::Models::CustomStreamTarget

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
        [ parent_path, "custom" ].compact.join("/")
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
        [ parent_path, "custom", id ].compact.join("/")
      end

    end
  end
end
