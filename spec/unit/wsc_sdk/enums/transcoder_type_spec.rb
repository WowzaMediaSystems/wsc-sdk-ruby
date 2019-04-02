####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
describe WscSdk::Enums::TranscoderType do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::TranscoderType::TRANSCODED).to eq("transcoded")
    expect(WscSdk::Enums::TranscoderType::PASSTHROUGH).to eq("passthrough")
  end

end
