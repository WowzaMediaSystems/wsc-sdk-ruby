####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/webmock_helper"
require "unit/helpers/object_endpoints"

describe WscSdk::ModelList do
  
  let(:client)      { WscSdk::Client.new }
  let(:endpoint)    { ObjectEndpoints.new(client) }

  it "can add a model to the list", unit_test: true do
    obj   = ObjectModel.new(endpoint)
    obj.ingest_attributes({ id: "abcd1234", name: "Test Object Model" }, write_to_read_only: true, mark_clean: true)
    list  = WscSdk::ModelList.new

    list.add(obj)

    expect(list.keys.length).to eq(1)
    expect(list.keys).to include("abcd1234")

    obj   = list["abcd1234"]
    expect(obj.class).to eq(ObjectModel)
    expect(obj.id).to eq("abcd1234")
    expect(obj.name).to eq("Test Object Model")
  end

  it "can add pagination by hash", unit_test: true do
    list  = WscSdk::ModelList.new
    expect(list.pagination.page).to eq(1)
    expect(list.pagination.total_pages).to eq(1)

    list.pagination = {
      page:  2,
      per_page:  1000,
      total_pages:  2,
      total_records:  2000,
      page_first_index: 0,
      page_last_index:  999
    }

    expect(list.pagination.page).to eq(2)
    expect(list.pagination.total_pages).to eq(2)

  end

  it "can add pagination by class", unit_test: true do
    list  = WscSdk::ModelList.new
    expect(list.pagination.page).to eq(1)
    expect(list.pagination.total_pages).to eq(1)

    list.pagination = WscSdk::Pagination.new(
      page:  2,
      per_page:  1000,
      total_pages:  2,
      total_records:  2000,
      page_first_index: 0,
      page_last_index:  999
    )

    expect(list.pagination.page).to eq(2)
    expect(list.pagination.total_pages).to eq(2)
  end


end
