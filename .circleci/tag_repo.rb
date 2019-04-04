#!/usr/bin/env ruby

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
  puts "  publish-staging      Publish the code documentation to the staging docs site."
  puts "  publish-production   Publish the code documentation to the production docs site."
  puts ""
  exit
end

available_tags = [
	"integration",
	"unit",
	"release",
	"publish-staging",
  "publish-production"
]

tags      = (available_tags & ARGV).map{ |t| t.downcase }.flatten

# Generate usage if we got a bad tag.
usage if (ARGV - tags).length > 0

tags = tags - ["unit"] if tags.include?("release") or tags.include?("publish")
tags = tags - ["integration"] if tags.include?("release") or tags.include?("publish")
tags = tags - ["publish"] if tags.include?("release")

puts "Tags: #{tags}"

tags.each do |tag|
  puts "Tagging the repo with #{tag}..."
  `cd #{WORK_DIR} && git push origin ":#{tag}" > /dev/null 2>&1`
  `cd #{WORK_DIR} && git tag --delete #{tag} > /dev/null 2>&1`
  `cd #{WORK_DIR} && git tag -a #{tag} -m "Used tag-for-build.sh on component=${component}" > /dev/null 2>&1`
	`cd #{WORK_DIR} && git push --tags > /dev/null 2>&1`
	puts " |> Tag updated!"
end
