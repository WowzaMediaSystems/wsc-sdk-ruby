####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'
require 'wsc_sdk/models/stream_target'

module WscSdk
  module Models

    # A model to represent a ULL Stream Target in the Wowza Streaming Cloud API.
    #
    class UllStreamTarget < WscSdk::Model

      model_name_singular :stream_target_ull
      model_name_plural   :stream_targets_ull

      attribute :id,                          :string,    access: :read
      attribute :name,                        :string,    required: true
      attribute :source_delivery_method,      :string,    required: true,   access: :new_model_access
      attribute :source_url,                  :string,    required: :source_url_required_if_pull
      attribute :type,                        :string,    access: :read
      attribute :provider,                    :string
      attribute :enabled,                     :boolean
      attribute :enable_hls,                  :boolean
      attribute :state,                       :string
      attribute :ingest_ip_whitelist,         :array
      attribute :region_override,             :string
      attribute :stream_name,                 :string,    access: :read
      attribute :primary_url,                 :string,    access: :read
      attribute :playback_urls,               :hash,      access: :read
      attribute :connection_code,             :string,    access: :read
      attribute :connection_code_expires_at,  :datetime,  access: :read
      attribute :created_at,                  :datetime,  access: :read
      attribute :updated_at,                  :datetime,  access: :read

      # Determines the access level of the model based on whether it's a new
      # model or not.
      #
      # @return [Symbol]
      #     Returns :read_write if it's a new model, or :read if it's not.
      #
      def new_model_access
        self.new_model? ? :read_write : :read
      end

      # Determines the requirement of the source_url field based on whether the
      # target has a `pull` source delivery method.
      #
      def source_url_required_if_pull
        self.source_delivery_method == WscSdk::Enums::DeliveryMethod::PULL
      end
    end
  end
end
