####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Include our client configuration
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present.
arguments                 = ask_for_arguments(__FILE__, stream_target_name: nil, primary_url: nil, stream_name: nil)

# Extract some data into convenience variables
custom_stream_targets     = $client.stream_targets.custom

# Build a RTMP/pull custom_stream_target using a predefined template, and modify a
# few values
name                      = arguments[0]
primary_url               = arguments[1]
stream_name               = arguments[2]
custom_stream_target_data = WscSdk::Templates::CustomStreamTarget.akamai_hls(name, primary_url, stream_name)

# Build the custom_stream_target object
custom_stream_target      = custom_stream_targets.build(custom_stream_target_data)

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
handle_api_error(saved, "There was an error creating the custom stream target") unless saved.success?

# Output the custom stream target
# Defined in helpers.rb
output_model_attributes(custom_stream_target, "Custom Stream Target: #{custom_stream_target.name}")
