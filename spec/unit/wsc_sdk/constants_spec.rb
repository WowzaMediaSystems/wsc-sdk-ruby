require "unit/spec_helper"
require "unit/webmock_helper"

describe WscSdk do

  it "properly defines constants", unit_test: true do
    expect(WscSdk::SDK_NAME).to eq("Wowza Streaming Cloud SDK")
    expect(WscSdk::VERSION).to start_with("1.3")
    expect(WscSdk::PATH_VERSION).to eq("v1.3")
    expect(WscSdk::HOSTNAME).to eq("https://api.cloud.wowza.com")
    expect(WscSdk::PRODUCTION_HOSTNAME).to eq(WscSdk::HOSTNAME)
    expect(WscSdk::SANDBOX_HOSTNAME).to eq("https://api-sandbox.cloud.wowza.com")
    expect(WscSdk::USER_AGENT).to eq("{\"name\": \"#{WscSdk::SDK_NAME}\", \"version\": \"#{WscSdk::VERSION}\", \"platform\": \"#{RUBY_PLATFORM}\", \"engine\": \"#{RUBY_ENGINE}\"}")
  end

end
