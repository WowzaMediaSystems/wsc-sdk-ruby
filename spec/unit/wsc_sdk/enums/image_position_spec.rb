require "unit/spec_helper"
describe WscSdk::Enums::ImagePosition do

  it "enumerates values properly", unit_test: true do

    expect(WscSdk::Enums::ImagePosition::TOP_LEFT).to eq("top-left")
    expect(WscSdk::Enums::ImagePosition::TOP_RIGHT).to eq("top-right")
    expect(WscSdk::Enums::ImagePosition::BOTTOM_LEFT).to eq("bottom-left")
    expect(WscSdk::Enums::ImagePosition::BOTTOM_RIGHT).to eq("bottom-right")

  end

end
