####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

# The root path of the SDK code base.
WSC_SDK_ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), ".."))

# The ./lib path of the SDK code base
WSC_SDK_LIB_PATH  = File.join(WSC_SDK_ROOT_PATH, "lib")

# The ./lib/wsc_sdk path of the SDK code base
WSC_SDK_PATH      = File.join(WSC_SDK_LIB_PATH, "wsc_sdk")

require 'logger'
require 'httparty'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'

require "wsc_sdk/constants"
require "wsc_sdk/errors"
require "wsc_sdk/configuration"
require "wsc_sdk/client"
require "wsc_sdk/schema"
require "wsc_sdk/schema_attribute"

Dir[File.join(WSC_SDK_PATH, "modules", "**", "*.rb")].each{ |f| require f }

require "wsc_sdk/enums"
Dir[File.join(WSC_SDK_PATH, "attributes", "**", "*.rb")].each{ |f| require f }
Dir[File.join(WSC_SDK_PATH, "enums", "**", "*.rb")].each{ |f| require f }

require "wsc_sdk/model"
require "wsc_sdk/pagination"
require "wsc_sdk/model_list"
Dir[File.join(WSC_SDK_PATH, "models", "**", "*.rb")].each{ |f| require f }

require "wsc_sdk/model_template"
Dir[File.join(WSC_SDK_PATH, "templates", "**", "*.rb")].each{ |f| require f }

require "wsc_sdk/endpoint"
Dir[File.join(WSC_SDK_PATH, "endpoints", "**", "*.rb")].each{ |f| require f }


module WscSdk

  # Generate class level attributes for the WscSdk module.
  #
  class << self
    attr_writer :configuration
  end

  # Get the SDK configuration object.
  #
  # @return [WscSdk::Configuration]
  #     The SDK configuration object.
  #
  def self.configuration
    @configuration ||= WscSdk::Configuration.new
  end

  # Provides a mechanism to configure the SDK given a block.
  #
  # @yield [configuration]
  #   Gives a configuration object to the block so it can be setup properly.
  #
  # @yieldparam configuration [WscSdk::Configuration]
  #   The SDK configuration object.
  #
  def self.configure
    yield(configuration)
  end

  # Returns an instance of the client configured using the SDK configuration
  #
  # @return [WscSdk::Client]
  #   An instance of the client object configured using the SDK configuration.
  #
  def self.client
    @client ||= WscSdk::Client.configured_instance
  end

end
