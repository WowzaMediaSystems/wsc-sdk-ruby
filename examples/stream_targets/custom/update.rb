####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments                 = ask_for_arguments(__FILE__, custom_stream_target_id: nil, new_stream_target_name: nil)

# Extract some data into convenience variables
custom_stream_targets     = $client.stream_targets.custom
custom_stream_target_id   = arguments[0]
name                      = arguments[1]

# Request the custom_stream_target object
custom_stream_target      = custom_stream_targets.find(custom_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(custom_stream_target, "There was an error finding the custom stream target") unless custom_stream_target.success?

# Update the custom_stream_target
custom_stream_target.name = "My updated SDK custom_stream_target"

# If the custom_stream_target is invalid, output the messages and exit
unless (custom_stream_target.valid?)
  puts "Custom Stream Target is invalid:"

  custom_stream_target.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved = custom_stream_target.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error saving the custom stream target") unless saved.success?

# Output the custom_stream_target details
# Defined in helpers.rb
output_model_attributes(custom_stream_target, "Custom Stream Target: #{custom_stream_target.name}")
