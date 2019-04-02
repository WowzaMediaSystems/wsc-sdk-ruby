####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

# Establish a client with your API authentication information
#
# This uses environment variables to set the API key and access key.  This
# approach is recommended to add a layer of protection against exposing your
# API keys.
#
raise "WSC_API_KEY environment variable is not set" unless ENV.has_key?('WSC_API_KEY')
raise "WSC_API_ACCESS_KEY environment variable is not set" unless ENV.has_key?('WSC_API_ACCESS_KEY')
raise "WSC_API_TEST_HOSTNAME environment variable is not set" unless ENV.has_key?('WSC_API_TEST_HOSTNAME')

# Logging is disabled by default, but you can turn on it on by uncommenting the
# logger.level line below.
logger = Logger.new(STDOUT)
logger.level = Logger::Severity::UNKNOWN # Disable logging output
logger.level = Logger::Severity::DEBUG # Enable logging output

WscSdk.configure do |config|
  config.api_key      = ENV['WSC_API_KEY']
  config.access_key   = ENV['WSC_API_ACCESS_KEY']
  config.logger       = logger
  config.hostname     = ENV['WSC_API_TEST_HOSTNAME']
end

$client     = WscSdk::Client.new
