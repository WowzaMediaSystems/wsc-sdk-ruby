####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]

# Request the specific transcoder
transcoder        = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error retrieving the transcoder") unless transcoder.success?

# Request the outputs list
list              = transcoder.outputs.list

# Handle an API error (in the helpers.rb file)
handle_api_error(list, "There was an error retrieving the outputs list") unless list.success?

# Output the list of outputs
# Defined in helpers.rb
output_model_list(list, "Outputs for transcoder '#{transcoder.name}':", false, :name)
