####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
describe WscSdk::Enums::IdleTimeout do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::IdleTimeout::NONE).to eq(0)
    expect(WscSdk::Enums::IdleTimeout::ONE_MINUTE).to eq(1)
    expect(WscSdk::Enums::IdleTimeout::TEN_MINUTES).to eq(600)
    expect(WscSdk::Enums::IdleTimeout::TWENTY_MINUTES).to eq(1200)
    expect(WscSdk::Enums::IdleTimeout::THIRTY_MINUTES).to eq(1800)
    expect(WscSdk::Enums::IdleTimeout::ONE_HOUR).to eq(3600)
    expect(WscSdk::Enums::IdleTimeout::SIX_HOURS).to eq(21600)
    expect(WscSdk::Enums::IdleTimeout::TWELVE_HOURS).to eq(43200)
    expect(WscSdk::Enums::IdleTimeout::ONE_DAY).to eq(86400)
    expect(WscSdk::Enums::IdleTimeout::TWO_DAYS).to eq(172800)
  end

  it "defines a range of values", unit_test: true do
    expect(WscSdk::Enums::IdleTimeout.values).not_to include(WscSdk::Enums::IdleTimeout::NONE - 1)
    expect(WscSdk::Enums::IdleTimeout.values).to include(WscSdk::Enums::IdleTimeout::NONE)
    expect(WscSdk::Enums::IdleTimeout.values).to include(WscSdk::Enums::IdleTimeout::TWO_DAYS)
    expect(WscSdk::Enums::IdleTimeout.values).not_to include(WscSdk::Enums::IdleTimeout::TWO_DAYS + 1)
  end
end
