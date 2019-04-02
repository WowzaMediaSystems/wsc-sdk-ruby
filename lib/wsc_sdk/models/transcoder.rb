####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent a Transcoder in the Wowza Streaming Cloud API.
    #
    class Transcoder < WscSdk::Model
      include WscSdk::TranscoderSharedMethods

      model_name_singular :transcoder
      model_name_plural   :transcoders

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------


      attribute :id,                      :string,    access: :read
      attribute :name,                    :string,    required: true
      attribute :transcoder_type,         :string,    required: true,     validate: Enums::TranscoderType.values,     default: Enums::TranscoderType::TRANSCODED
      attribute :billing_mode,            :string,    required: true,     validate: Enums::BillingMode.values,        default: Enums::BillingMode::PAY_AS_YOU_GO
      attribute :broadcast_location,      :string,    required: true,     validate: Enums::BroadcastLocation.values
      attribute :protocol,                :string,    required: true,     validate: Enums::Protocol.values
      attribute :delivery_method,         :string,    required: true,     validate: Enums::DeliveryMethod.values
      attribute :source_url,              :string,    required: :source_url_is_required?
      attribute :recording,               :boolean
      attribute :closed_caption_type,     :string,                        validate: Enums::ClosedCaptionType.values
      attribute :stream_extension,        :string
      attribute :stream_source_id,        :string
      attribute :delivery_protocols,      :array
      attribute :buffer_size,             :integer,                       validate: Enums::BufferSize.values
      attribute :low_latency,             :boolean
      attribute :stream_smoother,         :boolean
      attribute :idle_timeout,            :integer,                       validate: Enums::IdleTimeout.values
      attribute :play_maximum_connections,:integer
      attribute :disable_authentication,  :boolean
      attribute :username,                :string
      attribute :password,                :string
      attribute :description,             :string

      attribute :watermark,               :boolean,   default: false
      attribute :watermark_image,         :string
      attribute :watermark_position,      :string,                        validate: Enums::ImagePosition.values
      attribute :watermark_width,         :integer
      attribute :watermark_height,        :integer
      attribute :watermark_opacity,       :integer,                       validate: (0..100).to_a

      attribute :source_port,             :string,    access: :read
      attribute :domain_name,             :string,    access: :read
      attribute :application_name,        :string,    access: :read
      attribute :stream_name,             :string,    access: :read
      attribute :direct_playback_urls,    :hash,      access: :read
      attribute :created_at,              :datetime,  access: :read
      attribute :updated_at,              :datetime,  access: :read

      # Determine if the source_url attribute is required.
      #
      def source_url_is_required?
        delivery_method == Enums::DeliveryMethod::PULL
      end

      #---------------------------------------------------------------------------
      #    _                   _      _   _
      #   /_\   ______ ___  __(_)__ _| |_(_)___ _ _  ___
      #  / _ \ (_-<_-</ _ \/ _| / _` |  _| / _ \ ' \(_-<
      # /_/ \_\/__/__/\___/\__|_\__,_|\__|_\___/_||_/__/
      #
      #---------------------------------------------------------------------------


      # Outputs endpoint for outputs associated with the transcoder.
      #
      # @return [WscSdk::Endpoints::Outputs]
      #   An instance of the Outputs endpoint, with the results limited to the
      #   outputs associated with this trancoder.
      #
      def outputs
        @outputs ||= WscSdk::Endpoints::Outputs.new(endpoint.client, parent_path: endpoint.find_path(self.primary_key))
      end

      # Returns a URL where the current thumbnail image for the transcoder can be
      # retrieved
      #
      # @return [String]
      #   The URL of the thumbnail image.
      #
      def thumbnail_url
        return self.endpoint.thumbnail_url(self.id)
      end

      # Returns the current transcoding statistics for the transcoder.
      #
      # @return [WscSdk::Models::TranscoderStats]
      #   The current statistics for the transcoder.
      #
      def stats
        return self.endpoint.stats(self.id)
      end

      # Regenerates the connection code for the transcoder.
      #
      # @return [WscSdk::Models::TranscoderConnectionCode]
      #   The regenerated connection code information.
      #
      def regenerate_connection_code
        return self.endpoint.regenerate_connection_code(self.id)
      end

      # Enables all of the stream targets assigned to the transcoder.
      #
      # @return [WscSdk::Model::TranscoderStreamTargetState]
      #
      def enable_all_stream_targets
        return self.endpoint.enable_all_stream_targets(self.id)
      end

      # Disables all of the stream targets assigned to the transcoder.
      #
      # @return [WscSdk::Model::TranscoderStreamTargetState]
      #
      def disable_all_stream_targets
        return self.endpoint.disable_all_stream_targets(self.id)
      end

    end
  end
end
