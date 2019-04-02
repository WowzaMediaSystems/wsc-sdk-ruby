####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Get our client
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments                 = ask_for_arguments(__FILE__, wowza_stream_target_id: nil, new_stream_target_name: nil)

# Extract some data into convenience variables
wowza_stream_targets      = $client.stream_targets.wowza
wowza_stream_target_id    = arguments[0]
name                      = arguments[1]

# Request the wowza_stream_target object
wowza_stream_target       = wowza_stream_targets.find(wowza_stream_target_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(wowza_stream_target, "There was an error finding the wowza stream target") unless wowza_stream_target.success?

# Update the wowza_stream_target
wowza_stream_target.name  = name

# If the wowza_stream_target is invalid, output the messages and exit
unless (wowza_stream_target.valid?)
  puts "Wowza Stream Target is invalid:"

  wowza_stream_target.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved                     = wowza_stream_target.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error saving the wowza stream target") unless saved.success?

# Output the wowza_stream_target details
# Defined in helpers.rb
output_model_attributes(wowza_stream_target, "Wowza Stream Target: #{wowza_stream_target.name}")
