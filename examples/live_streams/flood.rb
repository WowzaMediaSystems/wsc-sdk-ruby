####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk"
require_relative "../client"  # Get our client
require_relative "../helpers" # Include some helpers to make the code more direct

# Ensure the args passed in are present, if not ask for them.
arguments       = ask_for_arguments(__FILE__, { pagination_page: 1, pagination_per_page: 25 })

# Extract some data into convenience variables

page            = arguments[0]   # First argument is the page number (default: 1)
per_page        = arguments[1]   # Second argument is the items per page (default: 25, max: 1000)



mutex = Mutex.new

live_stream_thread = Thread.new {
  list = nil

  mutex.synchronize {
    models          = $client.live_streams
    # Request the list of live_streams using pagination
    list            = models.list(pagination: { page: page.to_i, per_page: per_page.to_i })

    # Handle an API error (in the helpers.rb file)
    handle_api_error(list, "There was an error retrieving the list of live streams") unless list.success?
  }

  start         = Time.now.to_f
  last_request  = nil
  request_num   = 1
  list.each do |id, model|
    model = nil
    mutex.synchronize {
      model         = $client.live_streams.find(id)

      # Handle an API error (in the helpers.rb file)
      handle_api_error(model, "There was an error retrieving the live stream") unless model.success?
    }

    elapsed       = Time.now.to_f - start
    duration      = Time.now.to_f - (last_request || Time.now.to_f)
    last_request  = $client.last_request_time
    puts "Requested #{model.class.name.split("::").last}: #{id} | Name: #{model.name} | ##{request_num} | Duration: #{duration} | Elapsed: #{elapsed}"
    request_num += 1
  end
}


live_stream_state_thread = Thread.new {
  begin
    list = nil

    mutex.synchronize {
      models          = $client.live_streams
      # Request the list of live_streams using pagination
      list            = models.list(pagination: { page: page.to_i, per_page: per_page.to_i })

      # Handle an API error (in the helpers.rb file)
      handle_api_error(list, "There was an error retrieving the list of live streams") unless list.success?
    }

    puts "State!!!!"
    start         = Time.now.to_f
    last_request  = nil
    request_num   = 1
    list.each do |id, model|
      puts "ID: #{id}"
      model = nil
      mutex.synchronize {
        begin
          model         = model.state
        rescue Exception => e
          puts "Live Stream State Error: #{exception.message} | #{exception.backtrace[0..8].join("\n")}"
        end

        # Handle an API error (in the helpers.rb file)
        handle_api_error(model, "There was an error retrieving the live stream state") unless model.success?
      }

      elapsed       = Time.now.to_f - start
      duration      = Time.now.to_f - (last_request || Time.now.to_f)
      last_request  = $client.last_request_time
      puts "Requested #{model.class.name.split("::").last}: #{id} | STate: #{model.state} | ##{request_num} | Duration: #{duration} | Elapsed: #{elapsed}"
      request_num += 1
    end
  rescue Exception => e
    puts "Live Stream State Error: #{exception.message} | #{exception.backtrace[0..8].join("\n")}"
  end
}

stream_target_thread = Thread.new {
  list = nil
  mutex.synchronize {
    models          = $client.stream_targets.wowza
    # Request the list of live_streams using pagination
    list            = models.list(pagination: { page: page.to_i, per_page: per_page.to_i })

    # Handle an API error (in the helpers.rb file)
    handle_api_error(list, "There was an error retrieving the list of live streams") unless list.success?
  }

  start         = Time.now.to_f
  last_request  = nil
  request_num   = 1
  list.each do |id, model|
    model = nil
    mutex.synchronize {
      model         = $client.stream_targets.wowza.find(id)
      # Handle an API error (in the helpers.rb file)
      handle_api_error(model, "There was an error retrieving the wowza stream target") unless model.success?
    }
    elapsed       = Time.now.to_f - start
    duration      = Time.now.to_f - (last_request || Time.now.to_f)
    last_request  = Time.now.to_f
    puts "Requested #{model.class.name.split("::").last}: #{id} | Name: #{model.name} | ##{request_num} | Duration: #{duration} | Elapsed: #{elapsed}"
    request_num += 1
  end
}

live_stream_thread.join
live_stream_state_thread.join
stream_target_thread.join
