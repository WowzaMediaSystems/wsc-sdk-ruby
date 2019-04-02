####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # A client to manage credentials and act as an entrypoint for the SDK and all
  # API interactions.
  #
  # @example Usage
  #
  #   !!!ruby
  #   api_key     = "[your-api-key]"
  #   access_key  = "[your-api-access-key]"
  #   client      = WscSdk::Client.new(api_key, access_key)
  #
  # @example Usage with Environment Variables: Shell Config
  #
  #   !!!bash
  #   export WSC_API_KEY=[your-api-key]
  #   export WSC_API_ACCESS_KEY=[your-api-access-key]
  #
  # @example Usage with Environment Variables: Client Config
  #
  #   !!!ruby
  #   client      = WscSdk::Client.new()
  #
  class Client
    include HTTParty

    # Maximum number of requests to execute per second.
    MAX_REQUESTS_PER_SECOND = 5

    base_uri WscSdk::HOSTNAME

    attr_accessor :api_key, :access_key, :path_version, :hostname, :base_path, :logger

    attr_reader :last_request_time

    # Create a new instance of the client.
    #
    # @param options    [Hash]
    #   A hash of options.
    #
    # @option options [String] :api_key
    #   The account's API key.  Used to generated signatures for the API request
    #   headers.
    #
    # @option options [String] :access_key
    #   The account's access key.  Used to identify the profile making the
    #   API requests.
    #
    # @option options [String] :hostname
    #   The hostname to use when generating requests to the API.
    #
    # @option options [Logger] :logger
    #   The logger to use when generating log output in the SDK.
    #
    # @option options [String] :version
    #   The version of the API to use when generating requests to the API.
    #
    def initialize(options={})
      @api_key        = options.fetch(:api_key,     WscSdk.configuration.api_key)
      @access_key     = options.fetch(:access_key,  WscSdk.configuration.access_key)
      @hostname       = options.fetch(:hostname,    WscSdk.configuration.hostname)
      @path_version   = options.fetch(:version,     WscSdk.configuration.version)
      @base_path      = ["", "api", @path_version].join("/")
      @logger         = options.fetch(:logger,      WscSdk.configuration.logger)
      self.class.base_uri(@hostname)
    end


    # Get the fully qualified request path for an API request.
    #
    # @param path [String]
    #   The path of the API request.
    #
    # @return [String]
    #   The fully qualified request path.
    #
    def full_request_path(path)
      [ base_path, path ].join("/")
    end


    # Outputs the details of the client as a string.
    #
    # @return [String] The details of the client.
    #
    def to_s
      "WSC SDK Client > hostname: #{hostname} | version: #{path_version} | base_path: #{base_path}"
    end
    #---------------------------------------------------------------------------
    #  ___         _           _     _
    # | __|_ _  __| |_ __  ___(_)_ _| |_ ___
    # | _|| ' \/ _` | '_ \/ _ \ | ' \  _(_-<
    # |___|_||_\__,_| .__/\___/_|_||_\__/__/
    #               |_|
    #---------------------------------------------------------------------------

    # Access the /transcoders endpoints
    #
    # @return [Wsc::Endpoints::Transcoders]
    #   An instance of the Transcoders endpoint class.
    #
    def live_streams
      WscSdk::Endpoints::LiveStreams.new(self)
    end

    # Access the /stream_targets endpoints
    #
    # @return [Wsc::Endpoints::StreamTargets]
    #   An instance of the StreamTargets endpoint class.
    #
    def stream_targets
      WscSdk::Endpoints::StreamTargets.new(self)
    end

    # Access the /transcoders endpoints
    #
    # @return [Wsc::Endpoints::Transcoders]
    #   An instance of the Transcoders endpoint class.
    #
    def transcoders
      WscSdk::Endpoints::Transcoders.new(self)
    end

    #---------------------------------------------------------------------------
    #  ___                      _     _  _              _ _ _
    # | _ \___ __ _ _  _ ___ __| |_  | || |__ _ _ _  __| | (_)_ _  __ _
    # |   / -_) _` | || / -_|_-<  _| | __ / _` | ' \/ _` | | | ' \/ _` |
    # |_|_\___\__, |\_,_\___/__/\__| |_||_\__,_|_||_\__,_|_|_|_||_\__, |
    #            |_|                                              |___/
    #---------------------------------------------------------------------------


    # Make a GET request against the API.
    #
    # @param path     [String]
    #   The path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    def get(path, options={})
      send_request(:get, path, options)
    end

    # Make a POST request against the API.
    #
    # @param path     [String]
    #   The path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    def post(path, options={})
      send_request(:post, path, options)
    end

    # Make a GET request against the API.
    #
    # @param path     [String]
    #   The path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    def put(path, options={})
      send_request(:put, path, options)
    end

    # Make a GET request against the API.
    #
    # @param path     [String]
    #   The path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    def patch(path, options={})
      send_request(:patch, path, options)
    end

    # Make a GET request against the API.
    #
    # @param path     [String]
    #   The path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    def delete(path, options={})
      send_request(:delete, path, options)
    end

    # A generic way to request against an endpoint in the API
    #
    # @param method [Symbol]
    #   The method to use to formulate the request.
    #
    # @param path [String]
    #   The path to the endpoint.  This shoudl not include the protocol, domain
    #   or base path information.  Only the endpoint path itself.
    #
    # @param body [Hash]
    #   A Hash of payload data to send in the request.  This data will not be
    #   presented in the request if it's a GET or DELETE method.
    #
    def request_endpoint(method, path, body={})
      begin
        options = {}
        options = { body: body } unless [:get, :delete].include?(method)
        response = send_request(method, path, options)
        return nil if response.body.to_s.empty?

        begin
          data = JSON.parse(response.body)
          return data
        rescue JSON::ParserError => jpe
          return build_exception_response(500, "Bad JSON returned by request: [#{method.to_s.upcase}] #{path}", jpe)
        end
      rescue Exception => e
        # return build_exception_response(500, "Exception while requesting endpoint: [#{method.to_s.upcase}] #{path}", e)
        raise e
      end
    end

    # Builds a structured hash to respond to an exception in the request_endpoint
    # method
    #
    # @param status [Integer]
    #   The status code of the response
    #
    # @param title [String]
    #   The title of the exception
    #
    # @param exception [Exception]
    #   The exception to relay in the message.
    #
    private def build_exception_response(status, title, exception)
      {
        "meta" => {
          "status"      => status,
          "code"        => "ERR-#{status}-#{exception.class.name.gsub("::", "-")}",
          "title"       => title,
          "message"     => exception.message,
          "description" => exception.backtrace[0..5].join(" | ")
        }
      }
    end

    # Get the correct headers for an API request, including the properly formed
    # signed authentication headers.
    #
    # @param request_path [String]
    #   The request path to generate the headers for.
    #
    # @param options      [Hash]
    #   A hash of options
    #
    # @option options [Time] :timestamp
    #   The timestamp of the request.
    #
    # @option options [String] :content_type
    #   ("multipart/form-data") The content type to return in the headers.
    #
    # @return [Hash]
    #   A hash of request headers.
    #
    def generate_headers(request_path, options={})
      timestamp     = options.fetch(:timestamp, Time.now.to_i)
      request_path  = request_path.split("?").first.chomp("/")
      data          = "#{timestamp}:#{request_path}:#{api_key}"
      signature     = OpenSSL::HMAC.hexdigest("SHA256", api_key, data)
      content_type  = options.fetch(:content_type, "multipart/form-data")

      {
        'User-Agent'      => WscSdk::USER_AGENT,
        'Wsc-Access-Key'  => access_key,
        'Wsc-Timestamp'   => timestamp.to_s,
        'Wsc-Signature'   => signature,
        'Content-Type'    => content_type
      }
    end

    # Generate a set of request params for an API request
    #
    # @param options [Hash]
    #   A hash of options.
    #
    # @option options [Hash] :params
    #   A hash of query params or body content to be sent in the request.
    #
    # @option options [Hash] :pagination
    #   Pagination configuration options.
    #
    # @option options [Hash] :filters
    #   Filter configuration options.
    #
    def request_params(options={})
      pagination  = options.fetch(:pagination, nil)
      filters     = options.fetch(:filters, nil)
      params      = options.fetch(:params, {})

      if pagination
        params[:page] = pagination.fetch(:page, 1)
        params[:per_page] = pagination.fetch(:per_page, 25)
      end

      if filters
        if filters.is_a?(Hash)
          filter_index = 0
          filters.each do |key, value|
            params["filter[#{filter_index}][field]"] = key
            params["filter[#{filter_index}][eq]"] = value
            filter_index += 1
          end
        end
      end

      params
    end

    # Get debug information about the client configuration
    #
    def info
      {
        access_key:     ("#{access_key[0..5]}****#{access_key[-6..-1]}" rescue "invalid"),
        api_key:        ("#{api_key[0..5]}****#{api_key[-6..-1]}" rescue "invalid"),
        base_path:      base_path,
        hostname:       hostname,
        path_version:   path_version,
        logger:         (logger.class.name rescue "nil"),
        logger_level:   (logger.level rescue "nil"),
        throttle:       MAX_REQUESTS_PER_SECOND,
        user_agent:     WscSdk::USER_AGENT
      }
    end

    # Send a request to the API.
    #
    # @param method   [Symbol]
    #   The method verb for the request (:get, :post, :put, :patch, :delete)
    #
    # @param path     [String]
    #   The API path to request.
    #
    # @param options  [Hash]
    #   A hash of options.
    #
    # @option options [Hash] :params
    #   A hash of query params or body content to be sent in the request.
    #
    # @option options [Hash] :pagination
    #   Pagination configuration options.
    #
    # @option options [Hash] :filters
    #   Filter configuration options.
    #
    private def send_request(method, path, options={})
      wait_time = 0
      unless @last_request_time.nil?
        delay_time  = 1.0/MAX_REQUESTS_PER_SECOND
        elapsed     = Time.now.to_f - @last_request_time.to_f
        wait_time   = delay_time - elapsed
        wait_time   = 0   if wait_time < 0
        sleep(wait_time)  if wait_time > 0
      end
      @last_request_time = Time.now.to_f

      data          = {}
      full_path     = full_request_path(path)
      headers       = options.fetch(:headers, {})
      content_type  = headers.fetch(:content_type, "application/json")

      case method.to_sym
      when :get
        data[:query]  = request_params(options)
        data.delete(:query) if data[:query].empty?
      else
        data[:body]   = options[:body].to_json
      end

      data[:headers] = generate_headers(full_path, content_type: content_type)

      logger.debug("[WSC SDK] Endpoint Request  : [#{method.to_s.upcase}] #{hostname}#{full_path} #{data}")

      # Send the HTTParty call for the provided method.
      response = self.class.send(method.to_sym, full_path, data)
      logger.debug("[WSC SDK] Endpoint Response : [#{response.code}] #{response.body} | Throttle: #{wait_time}s")
      response
    end

    # Get an instance of the Client built using the SDK configuration object.
    #
    # @return [WscSdk::Client]
    #   The configured instance of the client.
    #
    def self.configured_instance
      @@client_instance ||= WscSdk::Client.new
    end

    # Convert a file to a base64 encoded string.
    #
    # @param file_path [String]
    #   A valid path to a file that should be converted to base64 encoding
    #
    # @return [String]
    #   The base64 encoded string that represents the file.
    #
    # @raise []
    def self.file_to_base64(file_path)
      raise ArgumentError.new("Could not convert the specified file to Base64, the file couldn't be found: #{file_path}") unless File.exists?(file_path)
      Base64.encode64(File.open(file_path, "rb").read)
    end
  end
end
