####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil, output_id: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]
output_id         = arguments[1]

# Request the specific transcoder
transcoder        = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error retrieving the transcoder") unless transcoder.success?

# Request the specific output
output            = transcoder.outputs.find(output_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(output, "There was an error retrieving the output") unless transcoder.success?

# Request the outputs list
list              = output.output_stream_targets.list

# Handle an API error (in the helpers.rb file)
handle_api_error(list, "There was an error retrieving the output stream targets list") unless list.success?

# Output the list of output stream targets
# Defined in helpers.rb
output_model_list(list, "Outputs Stream Targets for Output '#{output.name}':")
