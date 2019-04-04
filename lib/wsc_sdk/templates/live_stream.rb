####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Templates

    # Templates for generating Live Streams
    #
    class LiveStream < ModelTemplate

      # A template to build a Wowza Streaming Engine Live Stream with
      # single-bitrate delivery
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.wse_single_bitrate(name, width, height, modifiers={})
        self.merge({
          name:                   name,
          encoder:                WscSdk::Enums::Encoder::WOWZA_STREAMING_ENGINE,
          broadcast_location:     WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:     width,
          aspect_ratio_height:    height,
          delivery_type:          WscSdk::Enums::DeliveryType::SINGLE_BITRATE,
          delivery_method:        WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end

      # A template to build a Wowza Streaming Engine Live Stream with
      # single-bitrate delivery
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.wse_multi_bitrate(name, width, height, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::WOWZA_STREAMING_ENGINE,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height,
          delivery_type:              WscSdk::Enums::DeliveryType::MULTI_BITRATE,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end

      # A template to build a Wowza GoCoder Live Stream with
      # multi-bitrate delivery
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.gocoder(name, width, height, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::WOWZA_GOCODER,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PUSH
        }, modifiers)
      end


      # A template to build an IP Camera Live Stream with with RTSP/PULL
      # delivery.
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [String] source_url
      #   The source url of the IP camera.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.ip_camera(name, width, height, source_url, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::IP_CAMERA,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height,
          source_url:                 source_url,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PULL
        }, modifiers)
      end

      # A template to build an Other RTMP/PUSH Live Stream
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtmp_push(name, width, height, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::OTHER_RTMP,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PUSH,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height
        }, modifiers)
      end

      # A template to build an Other RTMP/PULL Live Stream
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [String] source_url
      #   The source url of the IP camera.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtmp_pull(name, width, height, source_url, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::OTHER_RTMP,
          protocol:                   WscSdk::Enums::Protocol::RTMP,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PULL,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height,
          source_url:                 source_url
        }, modifiers)
      end


      # A template to build an Other RTSP/PUSH Live Stream
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtsp_push(name, width, height, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::OTHER_RTSP,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PUSH,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height
        }, modifiers)
      end

      # A template to build an Other RTSP/PULL Live Stream
      #
      # @param [String] name
      #   The name of the live stream.
      #
      # @param [Integer] width
      #   The width of the largest rendition of the stream.
      #
      # @param [Integer] height
      #   The height of the largest rendition of the stream.
      #
      # @param [String] source_url
      #   The source url of the IP camera.
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.rtsp_pull(name, width, height, source_url, modifiers={})
        self.merge({
          name:                       name,
          encoder:                    WscSdk::Enums::Encoder::OTHER_RTSP,
          delivery_method:            WscSdk::Enums::DeliveryMethod::PULL,
          broadcast_location:         WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA,
          aspect_ratio_width:         width,
          aspect_ratio_height:        height,
          source_url:                 source_url
        }, modifiers)
      end

    end
  end
end
