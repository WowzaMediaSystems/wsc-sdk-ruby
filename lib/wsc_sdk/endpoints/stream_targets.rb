####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Endpoints

    # An endpoint to manage Stream Targets
    #
    class StreamTargets < WscSdk::Endpoint

      model_class WscSdk::Models::StreamTarget

      # Only allow the list action to be enabled.
      actions include: :list

      # Access the /stream_targets/wowza endpoints
      #
      # @return [Wsc::Endpoints::WowzaStreamTargets]
      #   An instance of the WowzaStreamTargets endpoint class.
      #
      def wowza
        WscSdk::Endpoints::WowzaStreamTargets.new(self.client, parent_path: self.list_path)
      end

      # Access the /stream_targets/custom endpoints
      #
      # @return [Wsc::Endpoints::CustomStreamTargets]
      #   An instance of the CustomStreamTargets endpoint class.
      #
      def custom
        WscSdk::Endpoints::CustomStreamTargets.new(self.client, parent_path: self.list_path)
      end

      # Access the /stream_targets/ull endpoints
      #
      # @return [Wsc::Endpoints::UllStreamTargets]
      #   An instance of the UllStreamTargets endpoint class.
      #
      def ull
        WscSdk::Endpoints::UllStreamTargets.new(self.client, parent_path: self.list_path)
      end

    end
  end
end
