require "unit/spec_helper"
describe WscSdk::Enums::BufferSize do

  it "enumerates values properly", unit_test: true do
    expect(WscSdk::Enums::BufferSize::NONE).to eq(0)
    expect(WscSdk::Enums::BufferSize::ONE_SECOND).to eq(1000)
    expect(WscSdk::Enums::BufferSize::TWO_SECONDS).to eq(2000)
    expect(WscSdk::Enums::BufferSize::THREE_SECONDS).to eq(3000)
    expect(WscSdk::Enums::BufferSize::FOUR_SECONDS).to eq(4000)
    expect(WscSdk::Enums::BufferSize::FIVE_SECONDS).to eq(5000)
    expect(WscSdk::Enums::BufferSize::SIX_SECONDS).to eq(6000)
    expect(WscSdk::Enums::BufferSize::SEVEN_SECONDS).to eq(7000)
    expect(WscSdk::Enums::BufferSize::EIGHT_SECONDS).to eq(8000)
  end

end
