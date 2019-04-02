module WscSdk

  # A class to contain the configuration of the WscSdk::Client.
  #
  class Configuration

    attr_accessor :api_key, :access_key, :version, :hostname, :logger

    def initialize
      @api_key    = ENV["WSC_API_KEY"]
      @access_key = ENV["WSC_API_ACCESS_KEY"]
      @logger     = ::Logger.new(STDOUT)
      @hostname   = WscSdk::HOSTNAME
      @version    = WscSdk::PATH_VERSION
    end

  end
end
