####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, live_stream_id: nil)

# Extract some data into convenience variables
live_streams     = $client.live_streams
live_stream_id   = arguments[0]

# Request the live_stream object
live_stream      = live_streams.find(live_stream_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(live_stream, "There was an error finding the live stream") unless live_stream.success?

# Request the live_stream state
state           = live_stream.state

# Handle an API error (in the helpers.rb file)
handle_api_error(state, "There was an error getting the live stream state") unless state.success?

# Ensure the live_stream is started
if state.state != 'started'
  # Start the live_stream and wait
  state = live_stream.start do |wait_state, live_stream_state|
    puts "Waiting for live_stream to start"
  end

  # Handle an API error (in the helpers.rb file)
  handle_api_error(state, "There was an error starting the live stream") unless state.success?
end

# Request the thumbnail url
thumbnail       = live_stream.thumbnail_url

# Handle an API error (in the helpers.rb file)
handle_api_error(thumbnail, "There was an error getting the live stream thumbnail url") unless thumbnail.success?

# Output the thumbnail URL
# Defined in helpers.rb
output_model_attributes(thumbnail, "Live Stream Thumbnail:")
