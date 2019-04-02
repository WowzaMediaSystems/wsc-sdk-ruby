####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
describe WscSdk::Enums::PlayerType do

  it "enumerates values properly", unit_test: true do

    expect(WscSdk::Enums::PlayerType::ORIGINAL_HTML5).to eq("original_html5")
    expect(WscSdk::Enums::PlayerType::WOWZA).to eq("wowza_player")

  end

end
