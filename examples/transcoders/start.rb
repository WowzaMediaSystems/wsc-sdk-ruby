require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]

# Request the transcoder object
transcoder        = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error finding the transcoder") unless transcoder.success?

# Get the result of starting the transcoder
#
# NOTE: You can also start and wait for the transcoder state to transition to
# a started state.  See the `start_and_wait` example.
#
state             = transcoder.start

# Handle an API error (in the helpers.rb file)
handle_api_error(state, "There was an error starting the transcoder") unless state.success?

# Output the transcoder state
# Defined in helpers.rb
output_model_attributes(state, "Transcoder State:")
