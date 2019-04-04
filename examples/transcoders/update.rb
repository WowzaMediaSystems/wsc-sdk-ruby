####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil, new_transcoder_name: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]
transcoder_name   = arguments[1]

# Request the transcoder object
transcoder        = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error finding the transcoder") unless transcoder.success?

# Update the transcoder
transcoder.name   = transcoder_name

# If the transcoder is invalid, output the messages and exit
unless (transcoder.valid?)
  puts "Transcoder is invalid:"

  transcoder.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved             = transcoder.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error saving the transcoder") unless saved.success?

# Output the transcoder details
# Defined in helpers.rb
output_model_attributes(transcoder, "Transcoder: #{transcoder.name}")
