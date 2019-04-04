####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/enums/custom_provider'

module WscSdk
  module Templates

    # Templates for generating Custom Stream Targets
    #
    class CustomStreamTarget < ModelTemplate

      # A template to build an Akamai HLS custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.akamai_hd(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::AKAMAI_HD,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end

      # A template to build an Akamai HD custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.akamai_hls(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::AKAMAI_HLS,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end

      # A template to build an Akamai RTMP custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.akamai_rtmp(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::AKAMAI_RTMP,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end


      # A template to build a Limelight custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.limelight(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::LIMELIGHT,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end

      # A template to build an RTMP custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtmp(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::RTMP,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end

      # A template to build an UStream custom stream target
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] primary_url
      #   The primary URL of the stream target.
      #
      # @param [String] stream_name
      #   The name of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.ustream(name, primary_url, stream_name, modifiers={})
        self.merge({
          name:                         name,
          provider:                     WscSdk::Enums::CustomProvider::USTREAM,
          primary_url:                  primary_url,
          stream_name:                  stream_name
        }, modifiers)
      end

    end
  end
end
