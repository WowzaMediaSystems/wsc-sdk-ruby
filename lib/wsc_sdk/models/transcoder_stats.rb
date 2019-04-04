####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'
require 'wsc_sdk/models/transcoder_float_stat'
require 'wsc_sdk/models/transcoder_integer_stat'
require 'wsc_sdk/models/transcoder_string_stat'

module WscSdk
  module Models

    # A model to represent the Stats of a Transcoder in the Wowza Streaming
    # Cloud API.
    #
    class TranscoderStats < WscSdk::Model

      model_name_singular :transcoder
      model_name_plural   :transcoders

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :audio_codec,               :transcoder_string_stat, access: :read
      attribute :bits_in_rate,              :transcoder_float_stat, access: :read
      attribute :bits_out_rate,             :transcoder_float_stat, access: :read
      attribute :bytes_in_rate,             :transcoder_float_stat, access: :read
      attribute :bytes_out_rate,            :transcoder_float_stat, access: :read
      attribute :configured_bytes_out_rate, :transcoder_integer_stat, access: :read
      attribute :connected,                 :transcoder_boolean_stat, access: :read
      attribute :cpu,                       :transcoder_integer_stat, access: :read
      attribute :frame_size,                :transcoder_string_stat,  access: :read
      attribute :frame_rate,                :transcoder_float_stat, access: :read
      attribute :gpu_decoder_usage,         :transcoder_integer_stat, access: :read
      attribute :gpu_driver_version,        :transcoder_string_stat, access: :read
      attribute :gpu_encoder_usage,         :transcoder_float_stat, access: :read
      attribute :gpu_memory_usage,          :transcoder_float_stat, access: :read
      attribute :gpu_usage,                 :transcoder_integer_stat, access: :read
      attribute :height,                    :transcoder_integer_stat, access: :read
      attribute :keyframe_interval,         :transcoder_integer_stat, access: :read
      attribute :unique_views,              :transcoder_integer_stat, access: :read
      attribute :video_codec,               :transcoder_string_stat,  access: :read
      attribute :width,                     :transcoder_integer_stat, access: :read

    end
  end
end
