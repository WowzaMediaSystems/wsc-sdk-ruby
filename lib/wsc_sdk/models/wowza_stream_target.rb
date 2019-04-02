####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent a Wowza Stream Target in the Wowza Streaming Cloud API.
    #
    class WowzaStreamTarget < WscSdk::Model

      model_name_singular :stream_target_wowza
      model_name_plural   :stream_targets_wowza

      attribute :id,                          :string,    access: :read
      attribute :name,                        :string,    required: true
      attribute :type,                        :string,    access: :read
      attribute :provider,                    :string
      attribute :location,                    :string,    access: :new_location_access
      attribute :use_secure_ingest,           :boolean,   access: :new_model_access
      attribute :use_cors,                    :boolean,   access: :new_model_access
      attribute :stream_name,                 :string,    access: :read
      attribute :secure_ingest_query_param,   :string,    access: :read
      attribute :username,                    :string,    access: :read
      attribute :password,                    :string,    access: :read
      attribute :primary_url,                 :string,    access: :read
      attribute :backup_url,                  :string,    access: :read
      attribute :hds_playback_url,            :string,    access: :read
      attribute :hls_playback_url,            :string,    access: :read
      attribute :rtmp_playback_url,           :string,    access: :read
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

      # Location can only be set if its a new record and not an Akmai Cupertino
      # provider.
      #
      # @return [Symbol]
      #     Returns :read_write if it's a new model and not a Akamai Cupertino
      #     provider, or :read otherwise.
      #
      def new_location_access
        (self.new_model? and not self.provider.start_with?("akamai_cupertino")) ? :read_write : :read
      end

    end
  end
end
