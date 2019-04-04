####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Templates

    # Templates for generating Outputs
    #
    class Output < ModelTemplate

      # Generate a Full HD output (1920x1080).
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.full_hd(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  1080,
          aspect_ratio_width:   1920,
          bitrate_audio:        128,
          bitrate_video:        4000,
          h264_profile:         "high",
          framerate_reduction:  "0",
          keyframes:            "follow_source"
        }, modifiers)
      end

      # Generate an HD output (1280x720)
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.hd(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  720,
          aspect_ratio_width:   1280,
          bitrate_audio:        128,
          bitrate_video:        2600,
          h264_profile:         "high",
          framerate_reduction:  "0",
          keyframes:            "follow_source",
        }, modifiers)
      end


      # Generate an SD wide screen output (854x480)
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.sd_wide(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  480,
          aspect_ratio_width:   854,
          bitrate_audio:        128,
          bitrate_video:        1600,
          h264_profile:         "main",
          framerate_reduction:  "0",
          keyframes:            "follow_source",
        }, modifiers)
      end

      # Generate a larger sized low res output (640x360)
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.low_res_large(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  360,
          aspect_ratio_width:   640,
          bitrate_audio:        128,
          bitrate_video:        1024,
          h264_profile:         "main",
          framerate_reduction:  "0",
          keyframes:            "follow_source",
        }, modifiers)
      end

      # Generate a medium sized low res output (512x288)
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.low_res_medium(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  288,
          aspect_ratio_width:   512,
          bitrate_audio:        128,
          bitrate_video:        512,
          h264_profile:         "baseline",
          framerate_reduction:  "0",
          keyframes:            "follow_source",
        }, modifiers)
      end

      # Generate a smaller sized low res output (320x180)
      #
      # @param [Hash] modifiers
      #   A hash of key/value modifiers to change data in the template.
      #
      def self.low_res_small(modifiers={})
        self.merge({
          stream_format:        "audiovideo",
          passthrough_video:    false,
          passthrough_audio:    false,
          aspect_ratio_height:  180,
          aspect_ratio_width:   320,
          bitrate_audio:        128,
          bitrate_video:        320,
          h264_profile:         "baseline",
          framerate_reduction:  "0",
          keyframes:            "follow_source",
        }, modifiers)
      end
    end
  end
end
