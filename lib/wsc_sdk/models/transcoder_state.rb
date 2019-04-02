require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent the State of a Transcoder in the Wowza Streaming
    # Cloud API.
    #
    class TranscoderState < WscSdk::Model

      model_name_singular :transcoder
      model_name_plural   :transcoders

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :ip_address,  :string, access: :read
      attribute :state,       :string, access: :read
      attribute :uptime_id,   :string, access: :read

    end
  end
end