####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments               = ask_for_arguments(__FILE__, pagination_page: 1, pagination_per_page: 25)

# Extract some data into convenience variables
stream_targets_wowza    = $client.stream_targets.wowza
page                    = arguments[0]    # First argument is the page number (default: 1)
per_page                = arguments[1]   # Second argument is the items per page (default: 25, max: 1000)

# Request the list of stream_targets_wowza using pagination
list                    = stream_targets_wowza.list(pagination: { page: page.to_i, per_page: per_page.to_i })

# Handle an API error (in the helpers.rb file)
handle_api_error(list, "There was an error retrieving the list of the Wowza stream targets") unless list.success?

# Output the list of stream_targets_wowza
output_model_list(list, "Wowza Stream Targets: #{list.keys.length}", true, :name)
