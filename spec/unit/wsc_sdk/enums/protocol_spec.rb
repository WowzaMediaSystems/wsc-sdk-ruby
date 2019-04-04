####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
describe WscSdk::Enums::Protocol do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::Protocol::RTMP).to eq("rtmp")
    expect(WscSdk::Enums::Protocol::RTSP).to eq("rtsp")
    expect(WscSdk::Enums::Protocol::WOWZ).to eq("wowz")
  end

end
