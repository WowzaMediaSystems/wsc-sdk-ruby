require "unit/spec_helper"
describe WscSdk::Enums::DeliveryMethod do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::DeliveryMethod::PUSH).to eq("push")
    expect(WscSdk::Enums::DeliveryMethod::PULL).to eq("pull")
  end

end
