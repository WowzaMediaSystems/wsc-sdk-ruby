require "unit/spec_helper"
describe WscSdk::Enums::ClosedCaptionType do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::ClosedCaptionType::NONE).to eq("none")
    expect(WscSdk::Enums::ClosedCaptionType::CEA).to eq("cea")
    expect(WscSdk::Enums::ClosedCaptionType::ON_TEXT).to eq("on_text")
    expect(WscSdk::Enums::ClosedCaptionType::BOTH).to eq("both")
  end

end
