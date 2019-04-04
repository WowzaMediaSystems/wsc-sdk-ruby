####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil, output_id: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]
output_id         = arguments[1]

# Request the specific transcoder
transcoder        = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error retrieving the transcoder") unless transcoder.success?

# Request the specific output
output            = transcoder.outputs.find(output_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(output, "There was an error retrieving the output")  unless output.success?

# Modify the output
output.bitrate_audio = 256
output.bitrate_video = 8000

# Make sure the output is valid
unless output.valid?
  puts "Invalid Output:"
  output.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the results of saving the output
saved             = output.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error updating the output")  unless saved.success?

# If we've successfully found the output then output some output about the
# output
# Defined in helpers.rb
output_model_attributes(output, "Output: #{output.name}")
