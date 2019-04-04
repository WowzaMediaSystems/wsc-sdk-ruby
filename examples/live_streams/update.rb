####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, live_stream_id: nil, new_live_stream_name: nil)

# Extract some data into convenience variables
live_streams     = $client.live_streams
live_stream_id   = arguments[0]
live_stream_name = arguments[1]

# Request the live_stream object
live_stream      = live_streams.find(live_stream_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(live_stream, "There was an error finding the live stream") unless live_stream.success?

# Update the live_stream
live_stream.name   = live_stream_name

# If the live_stream is invalid, output the messages and exit
unless (live_stream.valid?)
  puts "Live Stream is invalid:"

  live_stream.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved = live_stream.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error saving the live stream") unless saved.success?

# Output the live_stream details
# Defined in helpers.rb
output_model_attributes(live_stream, "Live Stream: #{live_stream.name}")
