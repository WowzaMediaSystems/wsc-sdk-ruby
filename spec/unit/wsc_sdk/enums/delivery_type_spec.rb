####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
describe WscSdk::Enums::DeliveryType do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::DeliveryType::SINGLE_BITRATE).to eq("single-bitrate")
    expect(WscSdk::Enums::DeliveryType::MULTI_BITRATE).to eq("multi-bitrate")
  end

end
