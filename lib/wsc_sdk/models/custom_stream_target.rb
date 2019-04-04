####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'
require 'wsc_sdk/models/stream_target'

module WscSdk
  module Models

    # A model to represent a Custom Stream Target in the Wowza Streaming Cloud API.
    #
    class CustomStreamTarget < WscSdk::Model

      model_name_singular :stream_target_custom
      model_name_plural   :stream_targets_custom

      attribute :id,                :string,    access: :read
      attribute :name,              :string,    required: true
      attribute :type,              :string,    access: :read
      attribute :provider,          :string
      attribute :use_https,         :boolean
      attribute :stream_name,       :string
      attribute :username,          :string
      attribute :password,          :string
      attribute :primary_url,       :string
      attribute :backup_url,        :string
      attribute :hds_playback_url,  :string
      attribute :hls_playback_url,  :string
      attribute :rtmp_playback_url, :string
      attribute :created_at,        :datetime,  access: :read
      attribute :updated_at,        :datetime,  access: :read
    end
  end
end
