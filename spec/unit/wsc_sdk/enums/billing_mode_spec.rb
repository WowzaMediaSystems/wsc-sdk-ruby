require "unit/spec_helper"
describe WscSdk::Enums::BillingMode do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::BillingMode::PAY_AS_YOU_GO).to eq("pay_as_you_go")
    expect(WscSdk::Enums::BillingMode::TWENTY_FOUR_SEVEN).to eq("twentyfour_seven")
  end

end
