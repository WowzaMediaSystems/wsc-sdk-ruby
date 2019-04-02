####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk
  module Endpoints

    # An endpoint to manage Live Streams
    #
    # @example Usage: Listing Live Streams
    #
    #   !!!ruby
    #   # View the WscSdk::Client documentation for how to establish a client instance.
    #   list = client.live_streams
    #
    #   list.each do |id, live_stream|
    #     puts "#{id}: #{live_stream.name}"
    #   ends
    #
    class LiveStreams < WscSdk::Endpoint

      model_class WscSdk::Models::LiveStream

      model_action :start,          :put, WscSdk::Models::LiveStreamState
      model_action :stop,           :put, WscSdk::Models::LiveStreamState
      model_action :reset,          :put, WscSdk::Models::LiveStreamState
      model_action :state,          :get, WscSdk::Models::LiveStreamState
      model_action :thumbnail_url,  :get, WscSdk::Models::LiveStreamThumbnailUrl
      model_action :stats,          :get, WscSdk::Models::LiveStreamStats
      model_action :regenerate_connection_code,
                                    :put, WscSdk::Models::LiveStreamConnectionCode

    end
  end
end
