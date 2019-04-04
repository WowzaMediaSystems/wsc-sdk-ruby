####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present
arguments         = ask_for_arguments(__FILE__, transcoder_id: nil, output_id: nil, stream_target_id: nil)

# Extract some data into convenience variables
transcoders       = $client.transcoders
transcoder_id     = arguments[0]
output_id         = arguments[1]
stream_target_id  = arguments[2]

# Request the specific transcoder
transcoder      = transcoders.find(transcoder_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(transcoder, "There was an error retrieving the transcoder") unless transcoder.success?

# Request the specific output
output          = transcoder.outputs.find(output_id)

# Handle an API error (in the helpers.rb file)
handle_api_error(output, "There was an error retrieving the output") unless transcoder.success?

# Build a Full HD output using a pre-defined template data, and modifying a
# few values
output_stream_target_data   = {
  stream_target_id: stream_target_id
}

# Build a new instance of the output object, and use it
output_stream_target        = output.output_stream_targets.build(output_stream_target_data)

# Make sure the output is valid
unless output_stream_target.valid?
  puts "Invalid Output Stream Target:"
  output.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the results of saving the output
saved = output_stream_target.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error creating the output stream target") unless saved.success?

# We've successfully saved the output then output some output about the
# output
# Defined in helpers.rb
output_model_attributes(output_stream_target, "Output Stream Target: #{output_stream_target.id}")
