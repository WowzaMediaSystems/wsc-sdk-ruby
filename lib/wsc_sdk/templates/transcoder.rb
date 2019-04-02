####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Templates

    # Templates for generating Transcoders
    #
    class Transcoder < ModelTemplate

      # A template to build an RTMP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] source_url
      #   The source URL of the encoded stream
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtmp_pull(name, source_url, modifiers={})
        self.merge({
          name:                   name,
          source_url:             source_url,
          broadcast_location:     WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          protocol:               WscSdk::Enums::Protocol::RTMP,
          delivery_method:        WscSdk::Enums::DeliveryMethod::PULL
        }, modifiers)
      end

      # A template to build an RTMP/PUSH transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] stream_source_id
      #   The ID of the stream source to push data to.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtmp_push(name, stream_source_id, modifiers={})
        self.merge({
          name:                   name,
          stream_source_id:       stream_source_id,
          broadcast_location:     WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          protocol:               WscSdk::Enums::Protocol::RTMP,
          delivery_method:        WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end


      # A template to build an RTSP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] source_url
      #   The source URL of the encoded stream
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtsp_pull(name, source_url, modifiers={})
        self.merge({
          name:                   name,
          source_url:             source_url,
          broadcast_location:     WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          protocol:               WscSdk::Enums::Protocol::RTSP,
          delivery_method:        WscSdk::Enums::DeliveryMethod::PULL
        }, modifiers)
      end

      # A template to build an RTSP/PULL transcoder
      #
      # @param [String] name
      #   The name of the transcoder
      #
      # @param [String] stream_source_id
      #   The ID of the stream source to push data to.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtsp_push(name, stream_source_id, modifiers={})
        self.merge({
          name:                   name,
          stream_source_id:       stream_source_id,
          broadcast_location:     WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          protocol:               WscSdk::Enums::Protocol::RTSP,
          delivery_method:        WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end
    end
  end
end
