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

# Get the result of stopping the live_stream.  We add a code block, which
# instructs the SDK to enter a wait loop and periodically polls the API
# for the live_stream state until either the `stopped` state is returned or
# the timeout period is reached.
state = live_stream.stop do |wait_state, live_stream_state|

  # This code will execute each time the state of the live_stream is polled
  # during the wait loop.  You can check the wait_state to determine what the
  # outcomes of each request are.

  if wait_state == :waiting
    # We're still waiting for the stopped state to be returned
    puts "Waiting..."
  elsif wait_state == :complete
    # We've successfully stopped the live_stream
    # Defined in helpers.rb
    output_model_attributes(live_stream_state, "Completed Live Stream State:")
  elsif wait_state == :timeout
    # A timeout occurs if the stop state isn't reached within the timeout
    # limit, which defaults to 30 seconds.

    puts "TIMEOUT: Could not stop the live stream within the timeout period."
  end
end

# Handle an API error (in the helpers.rb file)
handle_api_error(state, "There was an error stopping the live stream") unless state.success?

# Output the final live_stream state
# Defined in helpers.rb
output_model_attributes(state, "Final Live Stream State:")
