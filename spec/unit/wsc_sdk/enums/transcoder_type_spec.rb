require "unit/spec_helper"
describe WscSdk::Enums::TranscoderType do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::TranscoderType::TRANSCODED).to eq("transcoded")
    expect(WscSdk::Enums::TranscoderType::PASSTHROUGH).to eq("passthrough")
  end

end
