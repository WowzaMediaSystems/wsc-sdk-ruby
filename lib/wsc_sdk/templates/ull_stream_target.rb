####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/enums/delivery_method'

module WscSdk
  module Templates

    # Templates for generating ULL Stream Targets
    #
    class UllStreamTarget < ModelTemplate

      # A template to build an RTMP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.push(name, modifiers={})
        self.merge({
          name:                   name,
          source_delivery_method: WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end

      # A template to build an RTMP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] source_url
      #   The url of the stream source.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.pull(name, source_url, modifiers={})
        self.merge({
          name:                         name,
          source_delivery_method:       WscSdk::Enums::DeliveryMethod::PULL,
          source_url:                   source_url
        }, modifiers)
      end

    end
  end
end
