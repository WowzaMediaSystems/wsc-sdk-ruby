####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Include our client configuration
require_relative "../helpers" # Include some helpers to make the code more direct

arguments         = ask_for_arguments(__FILE__, transcoder_name: nil, source_url: nil)

# Extract some data into convenience variables
transcoders     = $client.transcoders
name            = arguments[0]
source_url      = arguments[1]

# Build a RTMP/pull transcoder using a predefined template.
transcoder_data = WscSdk::Templates::Transcoder.rtmp_pull(name, source_url)

# Build the transcoder object
transcoder      = transcoders.build(transcoder_data)

# If the transcoder is invalid, output the messages and exit
unless (transcoder.valid?)
  puts "Transcoder is invalid:"

  transcoder.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved = transcoder.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error creating the transcoder") unless saved.success?

# Output the transcoder details
# Defined in helpers.rb
output_model_attributes(transcoder, "Transcoder: #{transcoder.name}")
