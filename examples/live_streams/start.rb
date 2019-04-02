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

# Get the result of starting the live_stream
#
# NOTE: You can also start and wait for the live_stream state to transition to
# a started state.  See the `start_and_wait` example.
#
state = live_stream.start

# Handle an API error (in the helpers.rb file)
handle_api_error(state, "There was an error starting the live stream") unless state.success?

# Output the live_stream state
# Defined in helper.rb
output_model_attributes(state, "Live Stream State:")
