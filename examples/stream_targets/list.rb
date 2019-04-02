####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments               = ask_for_arguments(__FILE__, pagination_page: 1, pagination_per_page: 25)

# Extract some data into convenience variables
stream_targets  = $client.stream_targets
page                    = arguments[0]    # First argument is the page number (default: 1)
per_page                = arguments[1]   # Second argument is the items per page (default: 25, max: 1000)

# Request the list of stream_targets using pagination
list                    = stream_targets.list(pagination: { page: page.to_i, per_page: per_page.to_i })

# Handle an API error (in the helpers.rb file)
handle_api_error(list, "There was an error retrieving the list of stream targets") unless list.success?

# Output the list of stream_targets
# Defined in helpers.rb
output_model_list(list, "Stream Targets: #{list.keys.length}", true, :name)
