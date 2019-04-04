#!/usr/bin/env ruby

WORK_DIR = File.absolute_path(File.join(__dir__, "..", ".."))

ruby_files = Dir[File.join(WORK_DIR, "**/*.rb")]

ruby_files.each do |ruby_file|
  file_contents   = File.read(ruby_file)

  next if file_contents.nil?

  # Strip out existing preambles leading/trailing white space.
  file_contents   = file_contents.gsub(/^\#\#\#\#\>.*$/, "").strip

  # Extract the lines of the file
  lines           = file_contents.split("\n")

  preamble = [
    "####> This code and all components © 2015 – #{Time.new.year} Wowza Media Systems, LLC. All rights reserved.",
    "####> This code is licensed pursuant to the BSD 3-Clause License.",
    ""
  ]

  lines = preamble + lines

  puts "-"*80
  puts "File: #{ruby_file}"
  File.open(ruby_file, 'w') { |f| f.puts lines.join("\n") }
end
