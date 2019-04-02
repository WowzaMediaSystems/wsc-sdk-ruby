require "unit/spec_helper"
describe WscSdk::Enums::PlayerType do

  it "enumerates values properly", unit_test: true do

    expect(WscSdk::Enums::PlayerType::ORIGINAL_HTML5).to eq("original_html5")
    expect(WscSdk::Enums::PlayerType::WOWZA).to eq("wowza_player")

  end

end
