require "unit/spec_helper"
describe WscSdk::Enums::DeliveryType do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::DeliveryType::SINGLE_BITRATE).to eq("single-bitrate")
    expect(WscSdk::Enums::DeliveryType::MULTI_BITRATE).to eq("multi-bitrate")
  end

end
