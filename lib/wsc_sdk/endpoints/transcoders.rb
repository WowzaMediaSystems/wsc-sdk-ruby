####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Endpoints

    # An endpoint to manage Transcoders
    #
    # @example Usage: Listing Transcoders
    #
    #   !!!ruby
    #   # View the WscSdk::Client documentation for how to establish a client instance.
    #   list = client.transcoders
    #
    #   list.each do |id, transcoder|
    #     puts "#{id}: #{transcoder.name}"
    #   ends
    #
    class Transcoders < WscSdk::Endpoint

      model_class WscSdk::Models::Transcoder

      model_action :start,          :put, WscSdk::Models::TranscoderState
      model_action :stop,           :put, WscSdk::Models::TranscoderState
      model_action :reset,          :put, WscSdk::Models::TranscoderState
      model_action :state,          :get, WscSdk::Models::TranscoderState
      model_action :thumbnail_url,  :get, WscSdk::Models::TranscoderThumbnailUrl
      model_action :stats,          :get, WscSdk::Models::TranscoderStats

      model_action :enable_all_stream_targets,
                                    :put, WscSdk::Models::TranscoderStreamTargetState

      model_action :disable_all_stream_targets,
                                    :put, WscSdk::Models::TranscoderStreamTargetState

    end
  end
end
