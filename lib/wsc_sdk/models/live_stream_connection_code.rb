####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/model'
require 'wsc_sdk/models/transcoder_connection_code'

module WscSdk
  module Models

    # A model to represent the connection code of a Live Stream in the Wowza Streaming
    # Cloud API.
    #
    class LiveStreamConnectionCode < WscSdk::Model

      model_name_singular :live_stream
      model_name_plural   :live_streams


      #---------------------------------------------------------------------------
      #  ___     _
      # / __| __| |_  ___ _ __  __ _
      # \__ \/ _| ' \/ -_) '  \/ _` |
      # |___/\__|_||_\___|_|_|_\__,_|
      #
      #---------------------------------------------------------------------------

      attribute :connection_code,           :string, access: :read

    end
  end
end
