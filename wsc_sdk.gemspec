
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wsc_sdk/constants"

Gem::Specification.new do |spec|
  spec.name          = "wsc_sdk"
  spec.version       = WscSdk::VERSION
  spec.authors       = ["Jocko MacGregor"]
  spec.email         = ["jocko.macgregor@wowza.com"]

  spec.summary       = %q{An SDK for accessing the Wowza Streaming Cloud API.}
  spec.description   = %q{An SDK for accessing the Wowza Streaming Cloud API.}
  spec.homepage      = "https://www.wowza.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.3.1'

  spec.add_development_dependency "bundler", "> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec_junit_formatter"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "yard-coderay"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "request_interceptor"


  spec.add_dependency "httparty"
  spec.add_dependency "activesupport", "> 1.0.0"
  spec.add_dependency "tzinfo-data", "> 1.0.0"
end
