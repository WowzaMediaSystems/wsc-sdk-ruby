require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent the Stats of a Transcoder in the Wowza Streaming
    # Cloud API.
    #
    class TranscoderFloatStat < WscSdk::Model

      model_name_singular :transcoder
      model_name_plural   :transcoders

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :value,                     :float, access: :read
      attribute :status,                    :string, access: :read
      attribute :text,                      :string, access: :read
      attribute :units,                     :string, access: :read

      # Convert the stat to a string
      #
      def to_s
        str = "#{value.to_s}#{units}"
        str += " | #{self.text}" if status != "normal"
        str
      end

    end
  end
end
