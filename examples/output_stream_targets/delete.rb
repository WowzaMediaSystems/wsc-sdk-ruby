####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments               = ask_for_arguments(__FILE__, transcoder_id: nil, output_id: nil, output_stream_target_id: nil)

# Extract some data into convenience variables
transcoders             = $client.transcoders
transcoder_id           = arguments[0]
output_id               = arguments[1]
output_stream_target_id = arguments[2]

# Request the specific transcoder
transcoder              = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error retrieving the transcoder") unless transcoder.success?

# Request the specific output
output                  = transcoder.outputs.find(output_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(output, "There was an error retrieving the output") unless output.success?

output_stream_target    = output.output_stream_targets.find(output_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(output_stream_target, "There was an error retrieving the output stream target") unless output_stream_target.success?

# Delete the output
result                  = output_stream_target.delete

# Handle an API error (in the helpers.rb file)
handle_api_error(result, "There was an error deleting the output stream target") unless result.success?

# If we've successfully deleted the output, then output some output about the
# output. Note that the data for the output still exists locally in the
# SDK, however the ID has been removed since it no longer references a
# valid record in the API.
# Defined in helpers.rb
output_model_attributes(output_stream_target, "Output Stream Target: #{output_stream_target.id}")
