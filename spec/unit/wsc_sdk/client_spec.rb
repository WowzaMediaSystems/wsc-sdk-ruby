require "unit/spec_helper"
require "unit/webmock_helper"
require "unit/stubs/client"

describe WscSdk::Client do

  let(:api_key)           { "xxxxxxxx" }
  let(:access_key)        { "yyyyyyyy" }
  let(:configured_logger) { ::Logger.new(STDOUT) }
  let(:version)           { "v1.1" }

  before(:each) do
    WscSdk.configure do |config|
      config.api_key    = api_key
      config.access_key = access_key
      config.logger     = configured_logger
      config.hostname   = $simulator_hostname
      config.version    = version
    end
  end

  it "can return a configured instance", unit_test: true do
    client = WscSdk::Client.configured_instance

    expect(client.api_key).to eq("xxxxxxxx")
    expect(client.access_key).to eq("yyyyyyyy")
    expect(client.logger).to eq(configured_logger)
  end

  it "can instantiate itself properly", unit_test: true do
    hostname = "http://client_test.wowza.com"
    client = WscSdk::Client.new(hostname: hostname, version: version, logger: $logger)
    expect(client.api_key).to eq("xxxxxxxx")
    expect(client.access_key).to eq("yyyyyyyy")
    expect(client.hostname).to eq(hostname)
    expect(client.path_version).to eq(version)
    expect(client.logger).to eq($logger)
  end

  context "Client Endpoints" do
    let(:client) { WscSdk::Client.new }

    it "can return a transcoders endpoint", unit_test: true do
      transcoders = client.transcoders
      expect(transcoders.class).to eq(WscSdk::Endpoints::Transcoders)
    end
  end

  context "Request Endpoint" do
    let(:client) { WscSdk::Client.new(version: "v1.1") }

    it "can request an endpoint using GET", unit_test: true do
      result = client.request_endpoint(:get, "players")
      expect(result.keys).to include("players")
      expect(result["players"]).to be_an(Array)
      expect(result["players"].length).to eq(2)
    end

    it "can request an endpoint using POST", unit_test: true do
      result = client.request_endpoint(:post, "players/1", name: "Player 1")
      expect(result.keys).to include("player")
      expect(result["player"]).to be_a(Hash)
      expect(result["player"]["name"]).to eq("Player 1")
    end

    it "can request an endpoint using PUT", unit_test: true do
      result = client.request_endpoint(:put, "players/1", name: "Player 1 Updated")
      expect(result.keys).to include("player")
      expect(result["player"]).to be_a(Hash)
      expect(result["player"]["name"]).to eq("Player 1 Updated")
    end

    it "can request an endpoint using PATCH", unit_test: true do
      result = client.request_endpoint(:patch, "players/1", name: "Player 1 Updated")
      expect(result.keys).to include("player")
      expect(result["player"]).to be_a(Hash)
      expect(result["player"]["name"]).to eq("Player 1 Updated",)
    end

    it "can request an endpoint using DELETE", unit_test: true do
      result = client.request_endpoint(:delete, "players/1")
      expect(result).to be_nil
    end

    it "can generate an error with a bad JSON response", unit_test: true do
      result = client.request_endpoint(:get, "players/2")
      expect(result.keys).to include("meta")
      expect(result["meta"]["status"]).to eq(500)
      expect(result["meta"]["code"]).to eq("ERR-500-JSON-ParserError",)
      expect(result["meta"]["title"]).to eq("Bad JSON returned by request: [GET] players/2")
    end
  end

  context "Client Actions" do
    let(:client) { WscSdk::Client.new }

    it "will execute a get call against the api", unit_test: true do
      response = client.get('')
      response = client.get('', pagination: { page: 1, per_page: 50 })
      response = client.get('', filters: { foo: "bar" })
      response = client.get('', params: { foo: "bar" })
    end

    it "will execute a post call against the api", unit_test: true do
      response = client.post('')
    end

    it "will execute a put call against the api", unit_test: true do
      response = client.put('')
    end

    it "will execute a patch call against the api", unit_test: true do
      response = client.patch('')
    end

    it "will execute a delete call against the api", unit_test: true do
      response = client.delete('')
    end

    it "will generate the proper headers for the request", unit_test: true do
      timestamp       = Time.now.to_i
      request_path    = "/some/path/?with=params"
      signature_path  = request_path.split("?").first.chomp("/")
      signature_data  = "#{timestamp}:#{signature_path}:#{client.api_key}"
      signature       = OpenSSL::HMAC.hexdigest("SHA256", client.api_key, signature_data)

      headers         = client.generate_headers(request_path, timestamp: timestamp)

      expect(headers["User-Agent"]).to eq(WscSdk::USER_AGENT)
      expect(headers["Wsc-Access-Key"]).to eq(client.access_key)
      expect(headers["Wsc-Timestamp"].to_s).to eq(timestamp.to_s)
      expect(headers["Wsc-Signature"]).to eq(signature)
    end

    it "will convert a hash into request parameters properly", unit_test: true do
      options = {
        params: {
          param_1:  "foo",
          param_2:  "bar"
        },
        pagination: {
          page:     2,
          per_page: 30
        },
        filters: {
          name:     "test",
          active:   true
        }
      }

      request_params = client.request_params(options)

      expect(request_params[:param_1]).to eq("foo")
      expect(request_params[:param_2]).to eq("bar")
      expect(request_params[:page]).to eq(2)
      expect(request_params[:per_page]).to eq(30)
      expect(request_params["filter[0][field]"]).to eq(:name)
      expect(request_params["filter[0][eq]"]).to eq("test")
      expect(request_params["filter[1][field]"]).to eq(:active)
      expect(request_params["filter[1][eq]"]).to eq(true)
    end
  end

  context "Static Methods" do
    it "can convert a file to a Base64 string", unit_test: true do
      test_file_path        = File.expand_path(File.join(File.dirname(__FILE__), "..", "files"))
      test_image_file_path  = File.join(test_file_path, "images", "logo.png")
      base_64               = WscSdk::Client.file_to_base64(test_image_file_path)
      expect(base_64).to start_with("iVBORw0KGgoAAAANSUhEUgAAAWcAAADcCAYAAACswmCPAAAAAXNSR0IArs4c")
    end

    it "will raise an exception when trying to convert a file that doesn't exist to Base64", unit_test: true do
      expect{ WscSdk::Client.file_to_base64("this_file/doesnt/exist.png") }.to raise_error(ArgumentError)
    end
  end
end
