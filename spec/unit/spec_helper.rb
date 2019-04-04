####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'bundler/setup'

Bundler.setup

require 'wsc_sdk' # and any other gems you need

allow_localhost     = false           # Allow the tests to run against an actual localhost server.
$api_key            = "xxxxxxxx"
$access_key         = "yyyyyyyy"
$simulator_hostname = "wsc_sdk_test.wowza.com"
$hostname           = allow_localhost ? "http://localhost:3000" : $simulator_hostname
$version            = WscSdk::PATH_VERSION
$logger             = Logger.new(STDOUT)

# Disable logging output
$logger.level       = Logger::Severity::UNKNOWN

# Enable DEBUG logging output
# $logger.level     = Logger::Severity::DEBUG

RSpec.configure do |config|
  # some (optional) config here

  config.before(:each) do
    WscSdk.configure do |config|
      config.api_key    = $api_key
      config.access_key = $access_key
      config.logger     = $logger
      config.hostname   = $hostname
      config.version    = $version
    end
  end
end

# Performs a common set of tests against a model to make sure that the attribute
# is configured as expected.
#
def expect_attribute(model, attribute, type, config={})
  attribute = attribute.to_sym
  schema    = model.class.schema
  access    = config.fetch(:access, :read_write)
  default   = config.fetch(:default, nil)
  validate  = config.fetch(:validate, nil)
  required  = config.fetch(:required, false)

  expect(schema.has_attribute?(attribute)).to be_truthy, "Expected #{model.class.name} to have attribute :#{attribute.to_s} but does not."
  expect(schema[attribute].type).to eq(type), "Expected #{model.class.name} attribute :#{attribute.to_s} to be a #{type} but got #{schema[attribute].type} instead."
  expect(schema[attribute].access).to eq(access), "Expected #{model.class.name} attribute :#{attribute.to_s} access to be a #{access} but got #{schema[attribute].access} instead."

  if default.is_a?(Proc) or default.is_a?(Symbol)
    expect(schema[attribute].default.class).to eq(default.class)
  else
    expect(schema[attribute].default).to eq(default)
  end

  if validate.is_a?(Proc) or validate.is_a?(Symbol)
    expect(schema[attribute].validate.class).to eq(validate.class)
  else
    expect(schema[attribute].validate).to eq(validate)
  end

  if required.is_a?(Proc) or required.is_a?(Symbol)
    expect(schema[attribute].required.class).to eq(required.class)
  else
    expect(schema[attribute].required).to eq(required)
  end
end
