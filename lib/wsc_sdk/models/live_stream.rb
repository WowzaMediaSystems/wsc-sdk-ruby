####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent a Live Stream in the Wowza Streaming Cloud API.
    #
    class LiveStream < WscSdk::Model
      include WscSdk::TranscoderSharedMethods

      model_name_singular :live_stream
      model_name_plural   :live_streams

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :id,                                :string,    access: :read
      attribute :name,                              :string,    required: true
      attribute :transcoder_type,                   :string,    required: true,     validate: Enums::TranscoderType.values,     default: Enums::TranscoderType::TRANSCODED
      attribute :billing_mode,                      :string,    required: true,     validate: Enums::BillingMode.values,        default: Enums::BillingMode::PAY_AS_YOU_GO
      attribute :broadcast_location,                :string,    required: true,     validate: Enums::BroadcastLocation.values
      # attribute :protocol,                          :string,    required: true,     validate: Enums::Protocol.values
      attribute :encoder,                           :string,    required: true,     validate: Enums::Encoder.values
      attribute :delivery_method,                   :string,    required: true,     validate: Enums::DeliveryMethod.values,     default: Enums::DeliveryMethod::PUSH
      attribute :delivery_type,                     :string,    required: :delivery_type_is_required?,  validate: Enums::DeliveryType.values, default: Enums::DeliveryType::SINGLE_BITRATE
      attribute :recording,                         :boolean
      attribute :closed_caption_type,               :string,                        validate: Enums::ClosedCaptionType.values
      attribute :target_delivery_protocol,          :string,                        default: Enums::TargetDeliveryProtocol::HLS_HTTPS
      attribute :use_stream_source,                 :boolean
      attribute :stream_source_id,                  :string,    access: :read
      attribute :aspect_ratio_width,                :integer,   required: true
      attribute :aspect_ratio_height,               :integer,   required: true
      attribute :source_url,                        :string,    access: :write,     required: :source_url_is_required?,         default: :default_source_url
      attribute :connection_code,                   :string,    access: :read
      attribute :connection_code_expires_at,        :datetime,  access: :read
      attribute :disable_authentication,            :boolean,   access: :write
      attribute :username,                          :string,    access: :write
      attribute :password,                          :string,    access: :write
      attribute :delivery_protocols,                :array
      attribute :source_connection_information,     :hash,      access: :read
      attribute :direct_playback_urls,              :hash,      access: :read

      attribute :player_id,                         :string,    access: :read
      attribute :player_type,                       :string,                        validate: Enums::PlayerType.values
      attribute :player_responsive,                 :boolean
      attribute :player_width,                      :integer
      attribute :player_video_poster_image_url,     :string,    access: :read
      attribute :player_video_poster_image,         :string,    access: :write
      attribute :remove_player_video_poster_image,  :boolean,   access: :write
      attribute :player_countdown,                  :boolean
      attribute :player_countdown_at,               :datetime
      attribute :player_logo_image_url,             :string,    access: :read
      attribute :player_logo_image,                 :string,    access: :write
      attribute :remove_player_logo_image,          :boolean,   access: :write
      attribute :player_logo_position,              :string,                        validate: Enums::ImagePosition.values
      attribute :player_embed_code,                 :string,    access: :read
      attribute :player_hds_playback_url,           :string,    access: :read
      attribute :player_hls_playback_url,           :string,    access: :read

      attribute :hosted_page,                       :boolean,   access: :hosted_page_access
      attribute :hosted_page_title,                 :string
      attribute :hosted_page_description,           :string
      attribute :hosted_page_url,                   :string,    access: :read
      attribute :hosted_page_logo_image_url,        :string,    access: :read
      attribute :hosted_page_logo_image,            :string,    access: :write
      attribute :remove_hosted_page_logo_image,     :boolean,   access: :write
      attribute :hosted_page_sharing_icons,         :boolean


      attribute :created_at,                        :datetime,  access: :read
      attribute :updated_at,                        :datetime,  access: :read

      # Determine if the source_url attribute is required
      #
      def source_url_is_required?
        delivery_method == Enums::DeliveryMethod::PULL
      end

      # Determine if the delivery type opitons is required
      #
      def delivery_type_is_required?
        encoder == Enums::Encoder::WOWZA_STREAMING_ENGINE
      end

      # Determine if the hosted page option can be set
      #
      def hosted_page_access
        self.new_model? ? :read_write : :read
      end

      # Since the source_url is a write only attribute, when we update the
      # live stream the value is no longer present, so we will default it to
      # the value returned in the source_connection_information attribute, if it
      # is present.
      #
      def default_source_url
        sci = (self.attributes[:source_connection_information] || {})
        return sci[:source_url] if sci.has_key?(:source_url)
        return nil
      end

      #---------------------------------------------------------------------------
      #    _      _   _
      #   /_\  __| |_(_)___ _ _  ___
      #  / _ \/ _|  _| / _ \ ' \(_-<
      # /_/ \_\__|\__|_\___/_||_/__/
      #
      #---------------------------------------------------------------------------


      # Regenerates the connection code for the transcoder.
      #
      # @return [WscSdk::Models::TranscoderConnectionCode]
      #   The regenerated connection code information.
      #
      def regenerate_connection_code
        return self.endpoint.regenerate_connection_code(self.id)
      end

    end
  end
end
