####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/webmock_helper"

describe WscSdk::Configuration do

  it "can define a configuration using a block", unit_test: true do
    api_key     = "api_key"
    access_key  = "access_key"
    logger      = ::Logger.new(STDOUT)

    WscSdk.configure do |config|
      config.api_key    = api_key
      config.access_key = access_key
      config.logger     = logger
      config.hostname   = WscSdk::SANDBOX_HOSTNAME
    end

    client = WscSdk::Client.new

    expect(client.api_key).to eq(api_key)
    expect(client.access_key).to eq(access_key)
    expect(client.logger).to eq(logger)
  end

end
