####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "wsc_sdk/version"

# Define the base SDK module.
#
module WscSdk

  # The name of the SDK.
  SDK_NAME              = "Wowza Streaming Cloud SDK"

  # The default version to use when generating API requests.
  PATH_VERSION          = "v" << VERSION.split(".")[0..1].join(".")

  # The default hostname to use when generating API requests.
  HOSTNAME              = "https://api.cloud.wowza.com"

  # The hostname of the Production server.   This is an alias for
  # WscSdk::HOSTNAME
  PRODUCTION_HOSTNAME   = HOSTNAME

  # The hostname of the Sandbox server.
  SANDBOX_HOSTNAME      = "https://api-sandbox.cloud.wowza.com"

  # The user agent to report when generating API requests.
  USER_AGENT    = "{\"name\": \"#{SDK_NAME}\", \"version\": \"#{WscSdk::VERSION}\", \"platform\": \"#{RUBY_PLATFORM}\", \"engine\": \"#{RUBY_ENGINE}\"}"

end
