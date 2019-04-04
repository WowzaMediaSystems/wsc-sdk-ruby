####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, live_stream_id: nil)

# Extract some data into convenience variables
live_streams      = $client.live_streams
live_stream_id    = arguments[0]

# Request the live_stream object
live_stream       = live_streams.find(live_stream_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(live_stream, "There was an error finding the live stream") unless live_stream.success?

# Get the result of stopping the live_stream
#
# NOTE: You can also stop and wait for the live_stream state to transition to
# a stopped state.  See the `stop_and_wait` example.
#
state = live_stream.state

# Handle an API error (in the helpers.rb file)
handle_api_error(state, "There was an error getting the live stream state") unless state.success?

# Output the live_stream state
# Defined in helpers.rb
output_model_attributes(state, "Live Stream State:")
