require 'webmock/rspec'
$keyed_stubs = {}

# Builds stubs in webmock using a hash format.
#
# @example Stub Hash
#
# ```
# {
#   name: "Some Stub",                  # required
#   url: "http://someurl.to.stub.com",  # required
#   method: :get                        # required: :post, :put, :patch, :delete, :any
#   key: :unique_stub_key               # optional, if provided saves the stub so it can be referenced in remove_stub method.
#   response: {                         # optional
#     headers: { ... },                 # optional
#     body: { ... },                    # optional
#   }
# }
#
# @param [Array<Hash>] stubs An array of stub hashes to build in webmock.
def load_stubs(stubs)


  RSpec.configure do |config|
    config.before(:each) do
      stubs.each do |stub|
        request   = stub[:request] || {}
        response  = stub[:response] || {}
        stub_key  = stub[:key]

        hash_body = response.fetch(:body, nil)
        multiple_bodies = response.fetch(:bodies, nil)
        raw_body  = response.fetch(:raw_body, nil)

        body      = hash_body.to_json unless hash_body.nil?
        body      ||= multiple_bodies || raw_body

        stub      = stub_request(stub[:method], stub[:url]).
          with(
            headers: {
              'User-Agent'      => WscSdk::USER_AGENT
            }
          )

        if body.is_a?(Array)
          stub = stub.to_return(
            status:   response.fetch(:status, 200),
            body:     body[0].to_json,
            headers:  {}
          )

          if body.length > 1
            body.each_with_index do |next_body, idx|
              stub = stub.then if idx > 0
              stub = stub.to_return(
                status:   response.fetch(:status, 200),
                body:     body[idx].to_json,
                headers:  {}
              )
            end
          end
        else
          stub = stub.to_return(
            status:   response.fetch(:status, 200),
            body:     body,
            headers:  {}
          )
        end
        unless stub_key.nil?
          $keyed_stubs[stub_key.to_sym] = stub
        end
      end
    end
  end
end

def remove_stub(stub_key)
  return unless $keyed_stubs.has_key?(stub_key.to_sym)
  remove_request_stub($keyed_stubs[stub_key.to_sym])
end
