require "unit/spec_helper"
require "unit/webmock_helper"

describe WscSdk::SchemaAttribute do

  it "has an appropriate list of types", unit_test: true do

    expect(WscSdk::SchemaAttribute::TYPES).to include(:string)
    expect(WscSdk::SchemaAttribute::TYPES).to include(:integer)
    expect(WscSdk::SchemaAttribute::TYPES).to include(:boolean)
    expect(WscSdk::SchemaAttribute::TYPES).to include(:array)
    expect(WscSdk::SchemaAttribute::TYPES).to include(:hash)
    expect(WscSdk::SchemaAttribute::TYPES).to include(:datetime)

  end
end
