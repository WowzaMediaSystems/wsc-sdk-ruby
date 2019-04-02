require "unit/spec_helper"
describe WscSdk::Enums::BroadcastLocation do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_AUSTRALIA).to eq("asia_pacific_australia")
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_INDIA).to eq("asia_pacific_india")
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_JAPAN).to eq("asia_pacific_japan")
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_SINGAPORE).to eq("asia_pacific_singapore")
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_S_KOREA).to eq("asia_pacific_s_korea")
    expect(WscSdk::Enums::BroadcastLocation::ASIA_PACIFIC_TAIWAN).to eq("asia_pacific_taiwan")
    expect(WscSdk::Enums::BroadcastLocation::EU_BELGIUM).to eq("eu_belgium")
    expect(WscSdk::Enums::BroadcastLocation::EU_GERMANY).to eq("eu_germany")
    expect(WscSdk::Enums::BroadcastLocation::EU_IRELAND).to eq("eu_ireland")
    expect(WscSdk::Enums::BroadcastLocation::SOUTH_AMERICA_BRAZIL).to eq("south_america_brazil")
    expect(WscSdk::Enums::BroadcastLocation::US_CENTRAL_IOWA).to eq("us_central_iowa")
    expect(WscSdk::Enums::BroadcastLocation::US_EAST_S_CAROLINA).to eq("us_east_s_carolina")
    expect(WscSdk::Enums::BroadcastLocation::US_EAST_VIRGINIA).to eq("us_east_virginia")
    expect(WscSdk::Enums::BroadcastLocation::US_WEST_CALIFORNIA).to eq("us_west_california")
    expect(WscSdk::Enums::BroadcastLocation::US_WEST_OREGON).to eq("us_west_oregon")
  end

end
