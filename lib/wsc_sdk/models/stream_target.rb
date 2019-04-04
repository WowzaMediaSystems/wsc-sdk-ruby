####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent a Transcoder in the Wowza Streaming Cloud API.
    #
    class StreamTarget < WscSdk::Model

      model_name_singular :stream_target
      model_name_plural   :stream_targets

      attribute :id,                      :string,    access: :read
      attribute :name,                    :string,    required: true
      attribute :type,                    :string,    access: :read
      attribute :created_at,              :datetime,  access: :read
      attribute :updated_at,              :datetime,  access: :read

      # Generate a string to represent the Stream Target
      #
      def to_s
        "id: #{id} | type: #{type} | #{name}"
      end
    end
  end
end
