####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present, if not ask for them.
arguments         = ask_for_arguments(__FILE__, live_stream_id: nil)

# Extract some data into convenience variables
live_streams      = $client.live_streams
live_stream_id    = arguments[0]

# Request the live_stream object
live_stream       = live_streams.find(live_stream_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(live_stream, "There was an error finding the live stream") unless live_stream.success?

# Get the result of deleting the object from the API
deleted = live_stream.delete

# Handle an API error (in the helpers.rb file)
handle_api_error(deleted, "There was an error deleting the live stream") unless deleted.success?

# If we've successfully deleted the live_stream then output the details.
# Note that the data for the output still exists locally in the SDK, however the
# ID has been removed since it no longer references a valid record in the API.

# Defined in the helpers.rb file.
output_model_attributes(live_stream, "Live Stream: #{live_stream.name}")
