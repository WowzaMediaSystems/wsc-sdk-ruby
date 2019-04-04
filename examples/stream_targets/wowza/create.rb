####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Include our client configuration
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present.
arguments                 = ask_for_arguments(__FILE__, stream_target_name: nil, use_secure_ingest: false, use_cors: false)

# Extract some data into convenience variables
wowza_stream_targets      = $client.stream_targets.wowza

# Build a RTMP/pull wowza_stream_target using a predefined template, and modify a
# few values
name                      = arguments[0]
secure_ingest             = arguments[1].to_s.downcase.start_with?("t","y","1")
cors                      = arguments[2].to_s.downcase.start_with?("t","y","1")
wowza_stream_target_data  = WscSdk::Templates::WowzaStreamTarget.akamai_cupertino(name, secure_ingest, cors)

# Build the wowza_stream_target object
wowza_stream_target       = wowza_stream_targets.build(wowza_stream_target_data)

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
handle_api_error(saved, "There was an error creating the wowza stream target") unless saved.success?

# Output the wowza stream target
# Defined in helpers.rb
output_model_attributes(wowza_stream_target, "Wowza Stream Target: #{wowza_stream_target.name}")
