require "unit/spec_helper"
require "unit/webmock_helper"

require "unit/helpers/object_endpoints"
require "unit/helpers/schema_model"
require "unit/stubs/schema_model"

describe WscSdk::Schema do

  let(:client)          { WscSdk::Client.new }
  let(:endpoint)        { ObjectEndpoints.new(client) }

  let(:model) {
    SchemaModel.new(
      endpoint,
      id:                   "schema1234",
      name:                 "Test Schema Model",
      required_attr:        "This is required",           # :string,    required: true
      required_proc_attr:   "This is required by Proc",   # :string,    required: Proc.new{ |model| model.is_a?(SchemaObjectModel) }
      required_symbol_attr: "This is required by Symbol", # :string,    required: :is_required
      validate_array_attr:  1,                            # :integer,   validate: [1,2,3,4,5]
      validate_proc_attr:   2,                            # :integer,   validate: Proc.new{ |model, attribute, value| return value.nil? ? "Dude #{attribute} can't be nil" : nil }
      validate_symbol_attr: 3,                            # :integer,   validate: :is_valid
      access_read_attr:     true,                         # :boolean,   access: :read
      access_write_attr:    false,                        # :boolean,   access: :write
      string_attr:          "This is a string",           # :string
      boolean_attr:         true,                         # :boolean
      integer_attr:         2,
      as_attr:              "test"
    )
  }


  ## :default
  it "can determine the default or assigned value for an attribute", unit_test: true do
    expect(model.integer_attr).to eq(2)
    expect(model.default_attr).to eq(100)
  end

  it "can determine the default value for an attribute according to a Proc", unit_test: true do
    expect(model.default_proc_attr).to eq(80)
  end

  it "can determine the default value for an attribute according to a method symbol", unit_test: true do
    expect(model.default_symbol_attr).to eq(60)
  end

  ## :required
  it "can determine if an attribute is required", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.required_attr = nil
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:required_attr)
    expect(model.errors[:required_attr]).to include("is required")
  end

  it "can determine if an attribute is required according to a Proc", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.validate_proc_attr = 3
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:validate_proc_attr)
    expect(model.errors[:validate_proc_attr]).to include("Dude validate_proc_attr can't be nil")
  end

  it "can determine if an attribute is required according to a method symbol", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.required_symbol_attr = nil
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:required_symbol_attr)
    expect(model.errors[:required_symbol_attr]).to include("is required")
  end

  ## :validate

  it "can validate schema value according to an array of values", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.validate_array_attr = 6
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:validate_array_attr)
    expect(model.errors[:validate_array_attr]).to include("value must be one of the following: 1, 2, 3, 4, 5")
  end

  it "can validate schema value according to a Proc", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.validate_proc_attr = 4
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:validate_proc_attr)
    expect(model.errors[:validate_proc_attr]).to include("Dude validate_proc_attr can't be nil")
  end

  it "can validate schema value according to a method symbol", unit_test: true do
    expect(model.save.success?).to be_truthy

    model.validate_symbol_attr = -1
    expect(model.save.success?).to be_falsey
    expect(model.errors.keys).to include(:validate_symbol_attr)
    expect(model.errors[:validate_symbol_attr][0]).to eq("must be greater than 0")
  end

  ## :as
  it "can rename an attribute using the :as configuration", unit_test: true do
    expect{ test = model.as_attr }.not_to raise_error(Exception)
    expect{ test = model.some_attr }.to raise_error(Exception)

    expect(model.as_attr).to be_nil
    model.as_attr = "Some Value"
    expect(model.as_attr).to eq("Some Value")

    expect(model.attributes[:some_attr]).to eq("Some Value")
  end

  it "can get the appropriate attribute name from the attribute definition", unit_test: true do
    attribute_without_as  = SchemaModel.schema[:name]
    attribute_with_as     = SchemaModel.schema[:some_attr]

    expect(attribute_without_as).not_to be_nil
    expect(attribute_without_as.attribute_name).to eq(:name)

    expect(attribute_with_as).not_to be_nil
    expect(attribute_with_as.attribute_name).to eq(:as_attr)
  end
end
