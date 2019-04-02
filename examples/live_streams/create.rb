####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Include our client configuration
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present.
arguments         = ask_for_arguments(__FILE__, live_stream_name: nil, source_url: nil)

# Extract some data into convenience variables
live_streams      = $client.live_streams

# Build a RTMP/pull live_stream using a predefined template
name              = arguments[0]
source_url        = arguments[1]
live_stream_data  = WscSdk::Templates::LiveStream.rtmp_pull(name, 1920, 1080, source_url)

# Build the live_stream object
live_stream       = live_streams.build(live_stream_data)

# If the live_stream is invalid, output the messages and exit
unless (live_stream.valid?)
  puts "Live Stream is invalid:"

  live_stream.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved             = live_stream.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error creating the live stream") unless saved.success?

# Defined in the helpers.rb file.
output_model_attributes(live_stream, "Live Stream: #{live_stream.name}")
