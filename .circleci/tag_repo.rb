#!/usr/bin/env ruby

require_relative "../lib/wsc_sdk/version"
WORK_DIR = File.absolute_path(File.join(__dir__, ".."))


def usage
  puts ""
	puts "usage: ./.circleci/tag_repo.rb [ tag1 [ tag2 ... [ tagN ] ] ] ]"
	puts
	puts "Tags:"
	puts
	puts "  integration          Run integration tests upon commit"
  puts "  unit                 Run unit tests upon commit"
  puts "  release              Release the Gem asset (includes the unit and integration tags)"
  puts "  publish              Publish the code documentation"
  puts ""
  exit
end

available_tags = {
	"integration"  => "run-integration-tests",
	"unit"         => "run-unit-tests",
	"release"      => "release/v{{version}}",
	"publish"      => "publish/v{{version}}"
}

tags      = (available_tags.keys & ARGV).map{ |t| t.downcase }.flatten

# Generate usage if we got a bad tag.
usage if (ARGV - tags).length > 0

tags = tags - ["unit"] if tags.include?("release") or tags.include?("publish")
tags = tags - ["integration"] if tags.include?("release") or tags.include?("publish")
tags = tags - ["publish"] if tags.include?("release")

puts "Tags: #{tags}"

tags.each do |tag_key|
  tag     = available_tags[tag_key].gsub("{{version}}", WscSdk::VERSION)
  puts "Tagging the repo with #{tag}..."
	# puts "."
	`cd #{WORK_DIR} && git push origin ":#{tag}"`
  # `cd #{WORK_DIR} && git push origin ":#{tag}" > /dev/null 2>&1`

	`cd #{WORK_DIR} && git tag --delete #{tag}`
  # `cd #{WORK_DIR} && git tag --delete #{tag} > /dev/null 2>&1`

	`cd #{WORK_DIR} && git tag -a #{tag} -m "Used tag-repo.rb on for '#{tag_key}' tagging"`
  # `cd #{WORK_DIR} && git tag -a #{tag} -m "Used tag-for-build.sh on component=${component}" > /dev/null 2>&1`

	# `cd #{WORK_DIR} && git push --tags > /dev/null 2>&1`
	puts " |> Tag updated!"
end
#
# 	tag="start-component-build/${component}"
# 	puts
# 	puts "Tagging the repo with #{tag} for component=${component}..."
# 	# puts "."
# 	git push origin ":#{tag}" > /dev/null 2>&1
# 	# puts "."
# 	git tag --delete #{tag} > /dev/null 2>&1
# 	# puts "."
# 	git tag -a #{tag} -m "Used tag-for-build.sh on component=${component}" > /dev/null 2>&1
# 	# puts "."
# 	git push --tags > /dev/null 2>&1
# 	puts "Done Updating Tags"
# 	puts
#
# done
