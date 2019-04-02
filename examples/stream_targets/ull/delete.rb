require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments               = ask_for_arguments(__FILE__, ull_stream_target_id: nil)

# Extract some data into convenience variables
ull_stream_targets      = $client.stream_targets.ull
ull_stream_target_id    = arguments[0]

# Request the ull_stream_target object
ull_stream_target       = ull_stream_targets.find(ull_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(ull_stream_target, "There was an error finding the ull stream target") unless ull_stream_target.success?

# Get the result of deleting the object from the API
deleted = ull_stream_target.delete

# Handle an API error (in the helpers.rb file)
handle_api_error(deleted, "There was an error deleting the ull stream target") unless deleted.success?

# If we've successfully deleted the ull_stream_target, then output the details.
# Note that the data for the output still exists locally in the SDK, however the
# ID has been removed since it no longer references a valid record in the API.
# Defined in helpers.rb
output_model_attributes(ull_stream_target, "Ull Stream Target: #{ull_stream_target.name}")
