require "unit/spec_helper"
require "unit/webmock_helper"
require "unit/helpers/object_endpoints"

describe WscSdk::Errors do

  let(:client)      { WscSdk::Client.new }
  let(:endpoint)    { endpoint = ObjectEndpoints.new(client) }

  it "can generate an invalid_attributes error", unit_test: true do
    error = WscSdk::Errors.invalid_attributes(endpoint)
    expect(error.class).to eq(WscSdk::Models::Error)
    expect(error.success?).to be_falsey
    expect(error.status).to eq(422)
    expect(error.code).to eq("ERR-422-InvalidAttributes")
    expect(error.title).to eq("Invalid Attributes")
    expect(error.message).to eq("The model has invalid attribute values assigned to it.  Check the `WscSdk::Model#errors` property for more details.")
    expect(error.description).to eq("")
  end

  it "can generate an invalid_payload error", unit_test: true do
    error = WscSdk::Errors.invalid_payload(endpoint)
    expect(error.class).to eq(WscSdk::Models::Error)
    expect(error.success?).to be_falsey
    expect(error.status).to eq(422)
    expect(error.code).to eq("ERR-422-PayloadInvalid")
    expect(error.title).to eq("Payload Invalid")
    expect(error.message).to eq("The API request received an invalid payload.")
    expect(error.description).to eq("Turn on logging in DEBUG mode for more details about the issue.")
  end

  it "can generate a model_does_not_exist error", unit_test: true do
    error = WscSdk::Errors.model_does_not_exist(endpoint)
    expect(error.class).to eq(WscSdk::Models::Error)
    expect(error.success?).to be_falsey
    expect(error.status).to eq(422)
    expect(error.code).to eq("ERR-422-ModelDoesNotExist")
    expect(error.title).to eq("Model Does Not Exist")
    expect(error.message).to eq("You are attempting to access or update a record that does not exist yet. Try creating it first.")
    expect(error.description).to eq("")
  end

  it "can generate a model_exists error", unit_test: true do
    error = WscSdk::Errors.model_exists(endpoint)
    expect(error.class).to eq(WscSdk::Models::Error)
    expect(error.success?).to be_falsey
    expect(error.status).to eq(422)
    expect(error.code).to eq("ERR-422-ModelExists")
    expect(error.title).to eq("Model Exists")
    expect(error.message).to eq("You are attempting to create a record that already exists. Try updating the it.")
    expect(error.description).to eq("")
  end

end
