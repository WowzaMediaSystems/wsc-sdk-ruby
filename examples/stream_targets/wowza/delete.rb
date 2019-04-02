####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments                 = ask_for_arguments(__FILE__, wowza_stream_target_id: nil)

# Extract some data into convenience variables
wowza_stream_targets      = $client.stream_targets.wowza
wowza_stream_target_id    = arguments[0]

# Request the wowza_stream_target object
wowza_stream_target       = wowza_stream_targets.find(wowza_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(wowza_stream_target, "There was an error finding the wowza stream target") unless wowza_stream_target.success?

# Get the result of deleting the object from the API
deleted                   = wowza_stream_target.delete

# Handle an API error (in the helpers.rb file)
handle_api_error(deleted, "There was an error deleting the wowza stream target") unless deleted.success?

# If we've successfully deleted the wowza_stream_target, then output the details.
# Note that the data for the output still exists locally in the SDK, however the
# ID has been removed since it no longer references a valid record in the API.
# Defined in helpers.rb
output_model_attributes(wowza_stream_target, "Wowza Stream Target: #{wowza_stream_target.name}")
