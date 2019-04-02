####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/enums/wowza_provider'

module WscSdk
  module Templates

    # Templates for generating Wowza Stream Targets
    #
    class WowzaStreamTarget < ModelTemplate

      # A template to build an RTMP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [Boolean] secure_ingest
      #   An indication if the stream target shoudl use secure ingest.
      #
      # @param [Boolean] cors
      #   An indication if the stream target shoudl use cors headers.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.akamai_cupertino(name, secure_ingest, cors, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::WowzaProvider::AKAMAI_CUPERTINO,
          use_secure_ingest:            secure_ingest,
          use_cors:                     cors
        }, modifiers)
      end

      # A template to build an RTMP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [WscSdk::Enums::BroadcastLocation] location
      #   The geographic region for the stream target origin.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.akamai(name, location, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::WowzaProvider::AKAMAI,
          location:                     location
        }, modifiers)
      end

    end
  end
end
