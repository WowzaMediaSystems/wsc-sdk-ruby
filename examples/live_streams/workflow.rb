####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Include our client configuration
require_relative "../helpers" # Include some helpers to make the code more direct

# Turn down the logging
$client.logger.level = Logger::Severity::UNKNOWN # Disable logging output

# Ensure the args passed in are present.
arguments         = ask_for_arguments(__FILE__, live_stream_name: nil, source_url: nil, )

# Extract some data into convenience variables
live_streams      = $client.live_streams

# Build a RTMP/pull live_stream using a predefined template
name              = arguments[0]
source_url        = arguments[1]
live_stream_data  = WscSdk::Templates::LiveStream.rtsp_pull(name, 1920, 1080, source_url)

# Build the live_stream object
live_stream       = live_streams.build(live_stream_data)

# If the live_stream is invalid, output the messages and exit
unless (live_stream.valid?)
  puts "Live Stream is invalid:"

  live_stream.errors.each do |field, message|
    puts " - #{field}: #{message}"
  end
  exit
end

# Get the result of saving the object to the API
saved             = live_stream.save

# Handle an API error (in the helpers.rb file)
handle_api_error(saved, "There was an error creating the live stream") unless saved.success?

# Defined in the helpers.rb file.
output_model_attributes(live_stream, "Live Stream: #{live_stream.name}")

puts ""
puts "Starting Live Stream: #{live_stream.name}"
start_time = Time.now
# Get the result of starting the live_stream.  We add a code block, which
# instructs the SDK to enter a wait loop, and periodically polls the API
# for the live_stream state until either the `started` state is returned or
# the timeout period is reached.
state = live_stream.start(timeout: 300) do |wait_state, live_stream_state|

  # This code will execute each time the state of the live_stream is polled
  # during the wait loop.  You can check the wait_state to determine what the
  # outcomes of each request are.
  if wait_state == :waiting
    elapsed = Time.now - start_time
    # We're still waiting for the started state to be returned
    puts " |> Waiting for Live Stream Start... [#{elapsed}s]"
  elsif wait_state == :complete
    puts " |> Live stream has started!!!"
  elsif wait_state == :timeout
    # A timeout occurs if the start state isn't reached within the timeout
    # limit, which defaults to 30 seconds.

    puts "TIMEOUT: Could not start the live stream within the timeout period of 5 minutes."
    puts "The last state received was: #{live_stream_state.state} ... If the state is 'starting' be sure not to forgot to manually stop the live stream."
    exit
  end
end


puts ""
puts "Letting the Live Stream run for 5 minutes..."

# Setup a timer and elapsed time calculation.
start_time = Time.now
elapsed = start_time - Time.now

# Loop for 5 minutes
while(elapsed < 300)

  # Refresh the live_stream if the hoste_page_url isn't populated yet.
  live_stream.refresh if (live_stream.hosted_page and live_stream.hosted_page_url == "in_progress")

  # Request the current stats for the live stream.
  stats               = live_stream.stats

  # Request the current thumbnail for the live stream.
  thumbnail_url       = live_stream.thumbnail_url



  puts ""
  puts "Live Stream Stats: [Run Time: #{elapsed}s]"

  if (live_stream.hosted_page and live_stream.hosted_page_url != "in_progress")
    puts ""
    puts " |> You can view this live stream here: #{live_stream.hosted_page_url}"
    puts ""
  end

  if stats.success?
    max_attr_length = stats.attributes.map{ |k, v| k.to_s.length }.max
    stats.attributes.each do |attribute, value|
      puts " |> #{attribute.to_s.ljust(max_attr_length)} : #{value}"
    end
  else
    puts " !! Could not retrieve Live Stream stats"
  end

  if thumbnail_url.success?
    puts " |> #{"tumbnail_url".ljust(max_attr_length)} : #{thumbnail_url.thumbnail_url}"
  else
    puts " !! Could not retrieve Live Stream thumbnail"
  end

  puts ""
  puts "-"*80

  # Pause for a few seconds.  You don't need to poll stats or the thumbnail any
  # more frequently than every 5 seconds. The data isn't generated any more
  # frequently than that.
  sleep(5)
  elapsed = Time.now - start_time
end

# Stop the live stream!

# Get the result of stopping the live_stream.  We add a code block, which
# instructs the SDK to enter a wait loop and periodically polls the API
# for the live_stream state until either the `stopped` state is returned or
# the timeout period is reached.
state = live_stream.stop do |wait_state, live_stream_state|

  # This code will execute each time the state of the live_stream is polled
  # during the wait loop.  You can check the wait_state to determine what the
  # outcomes of each request are.

  if wait_state == :waiting
    # We're still waiting for the stopped state to be returned
    puts "Waiting..."
  elsif wait_state == :complete
    # We've successfully stopped the live_stream
    # Defined in helpers.rb
    output_model_attributes(live_stream_state, "Completed Live Stream State:")
  elsif wait_state == :timeout
    # A timeout occurs if the stop state isn't reached within the timeout
    # limit, which defaults to 30 seconds.

    puts "TIMEOUT: Could not stop the live stream within the timeout period."
    puts "The last state received was: #{live_stream_state.state} ... If the state is not 'stopping' or 'stopped' don't forgot to manually stop the live stream."
    exit
  end
end


# Delete the live stream.
puts "Deleting the live stream..."
deleted = live_stream.delete

puts " !! There was an error deleting the Live Stream, you will have to manually delete it" unless deleted.success?

puts ""
puts "Live Stream workflow complete!!"
