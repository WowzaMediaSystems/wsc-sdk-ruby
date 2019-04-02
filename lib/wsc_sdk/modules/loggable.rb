####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # A module that adds access to a logger.
  #
  # This will check to see if a Client object is available, and use its logger
  # otherwise it checks for an endpoint and will use its logger, as a last ditch
  # it will build a new plain old logger that logs to STDOUT.
  #
  # There is a logger attribute accessor, so you can overwrite the logger with
  # your own.
  #
  module Loggable

    # Returns an instance of a logger.
    #
    # @return [Logger]
    #   The assigned logger.
    #
    def logger
      if @logger.nil?
        if self.respond_to?(:client)
          @logger = self.client.logger
        elsif self.respond_to?(:endpoint)
          @logger = self.endpoint.logger
        end

        @logger ||= Logger.new(STDOUT)
      end

      @logger
    end

    # Sets the instance of logger.
    #
    # @param _logger [Logger]
    #   The logger instance to use for logging.
    def logger= _logger
      @logger = _logger
    end
  end
end
