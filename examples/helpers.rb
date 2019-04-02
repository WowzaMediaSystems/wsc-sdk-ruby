####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

# Generate usage output
def output_usage(filename, *args)
  puts
  puts "usage: bundle exec ruby #{filename} #{args.map{ |a| a.to_s}.join(" ")}"
  puts
  exit 1
end

def ask_for_argument(arg, default=nil, arg_width=20)
  message = "Enter argument value | #{arg.ljust(arg_width)} : "
  message += "[#{default}] " unless default.nil?

  print ">> #{message}"
  response = STDIN.gets.chomp.strip

  response = default if response.nil? or (response.length == 0)
  return response
end

# Ask for user input on any args not passed into the example script.
#
def ask_for_arguments(filename, args={})
  responses     = []
  arg_index     = 0
  max_arg_width = args.keys.map{ |k| k.to_s.length }.max

  puts ""
  args.each do |arg, default|
    value = ARGV[arg_index]
    arg_index += 1

    if value.nil? or (value.length == 0)
      response = ask_for_argument(arg.to_s, default, max_arg_width)
    else
      response = value
    end

    response = response.to_s
    output_usage(filename, args.keys) if response.length == 0

    responses << response
  end
  responses
end

# Exits the example, unless the result is a success
def handle_api_error(result, message)
  return if result.success?
  output_model_attributes(result, "The API Generated an error: #{message}")
  exit 1
end

# Outputs the attribute values of a model
#
# NOTE: This approach directly accesses the attributes for a model.  This is
# okay for reading data out of a model, but data assignment should be done using
# the getter (model.attribute) and setter (model.attribute=value) methods that
# are built into the model.  Otherwise you will be bypassing the structures
# necessary to validate the data, which may generate unwanted outcomes.
#
def output_model_attributes(model, title="Model Attributes")
  puts ""
  puts title
  puts ""
  max_attribute_width = model.attributes.keys.map{ |a| a.to_s.length }.max
  model.attributes.each do |attribute, value|
    puts " |>  #{attribute.to_s.ljust(max_attribute_width)} : #{value}"
  end
  puts ""
end

# Outputs a list of models.
#
def output_model_list(list, title="Model List", include_pagination=false, attribute=:to_s)
  puts ""
  puts title
  puts ""
  list.each do |id, model|
    puts " |> #{id.to_s.ljust(10)} : #{model.send(attribute)}"
  end

  if include_pagination
    # Output pagination information
    #
    puts ""
    puts "Showing records #{list.pagination.page_first_index+1} - #{list.pagination.page_last_index+1} of #{list.pagination.total_records}"
    puts "Currently on page #{list.pagination.page} of #{list.pagination.total_pages}"
    puts ""
    puts " |> Is first page  : #{list.pagination.first_page?}"
    puts " |> First page #   : #{list.pagination.first_page}"
    puts " |> Next page      : #{list.pagination.next_page}"
    puts " |> Previous page  : #{list.pagination.previous_page}"
    puts " |> Is last page   : #{list.pagination.last_page?}"
    puts " |> Last page #    : #{list.pagination.last_page}"
    puts ""
  end
end
