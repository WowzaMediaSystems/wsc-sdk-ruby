####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../../client"  # Include our client configuration
require_relative "../../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present.
arguments                 = ask_for_arguments(__FILE__, stream_target_name: nil, source_url: nil)

# Extract some data into convenience variables
ull_stream_targets        = $client.stream_targets.ull

# Build a RTMP/pull ull_stream_target using a predefined template, and modify a
# few values
name                      = arguments[0]
source_url                = arguments[1]
ull_stream_target_data    = WscSdk::Templates::UllStreamTarget.pull(name, source_url)

# Build the ull_stream_target object
ull_stream_target         = ull_stream_targets.build(ull_stream_target_data)

# If the ull_stream_target is invalid, output the messages and exit
unless (ull_stream_target.valid?)
  puts "ULL Stream Target is invalid:"

  ull_stream_target.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved = ull_stream_target.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error creating the ull stream target") unless saved.success?

# Output the ULL stream target
# Defined in helpers.rb
output_model_attributes(ull_stream_target, "ULL Stream Target: #{ull_stream_target.name}")
