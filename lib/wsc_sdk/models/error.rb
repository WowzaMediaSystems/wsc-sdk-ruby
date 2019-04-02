####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'

module WscSdk
  module Models

    # A model to represent an error returned from the API.
    #
    class Error < WscSdk::Model

      model_name_singular :meta
      model_name_plural   :meta

      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :status,      :integer, access: :read
      attribute :code,        :string,  access: :read
      attribute :title,       :string,  access: :read
      attribute :message,     :string,  access: :read
      attribute :description, :string,  access: :read

      #---------------------------------------------------------------------------
      #  ___ _        _
      # / __| |_ __ _| |_ ___
      # \__ \  _/ _` |  _/ -_)
      # |___/\__\__,_|\__\___|
      #
      #---------------------------------------------------------------------------

      # Since this is an error response the success is always false.
      #
      # @return [Boolean] An indication of the status of the API call.
      #
      def success?
        @success = false
      end

      # Generates a string with the details of the error.
      #
      def to_s
        "#{code} | #{title} | #{message} | #{description}"
      end
    end
  end
end
