####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Models

    # A model to repesent an Ouput Stream Target in the Wowza Streaming Cloud
    # API.
    #
    class OutputStreamTarget < WscSdk::Model

      model_name_singular :output_stream_target
      model_name_plural   :output_stream_targets


      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :id,                            :string,          access: :read
      attribute :output_id,                     :string,          access: :read
      attribute :stream_target_id,              :string
      attribute :use_stream_target_backup_url,  :boolean
      attribute :stream_target,                 :stream_target,   access: :read

      # Generate a string from the model data
      #
      def to_s
        "Stream Target ID: #{self.stream_target_id}"
      end
    end
  end
end
