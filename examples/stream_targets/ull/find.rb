####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments             = ask_for_arguments(__FILE__, ull_stream_target_id: nil)

# Extract some data into convenience variables
ull_stream_targets    = $client.stream_targets.ull
ull_stream_target_id  = arguments[0]

# Request the ull stream target object
ull_stream_target     = ull_stream_targets.find(ull_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(ull_stream_target, "There was an error finding the Wowza stream target") unless ull_stream_target.success?

# Output the ULL stream target
# Defined in helpers.rb
output_model_attributes(ull_stream_target, "Ull Stream Target: #{ull_stream_target.name}")
