####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/webmock_helper"

describe WscSdk::Pagination do
  it "generates a pagination object properly", unit_test: true do
    pagination = WscSdk::Pagination.new(
      page:  1,
      per_page:  1000,
      total_pages:  1,
      total_records:  1000,
      page_first_index: 0,
      page_last_index:  999
    )

    expect(pagination.page).to eq(1)
    expect(pagination.per_page).to eq(1000)
    expect(pagination.total_pages).to eq(1)
    expect(pagination.total_records).to eq(1000)
    expect(pagination.page_first_index).to eq(0)
    expect(pagination.page_last_index).to eq(999)
  end

  context "Pagination Behaviors" do
    let(:pagination) {
      WscSdk::Pagination.new(
        page:  2,
        per_page:  1000,
        total_pages:  5,
        total_records:  4500,
        page_first_index:  1000,
        page_last_index:  1999
      )
    }

    it "can determine the next page", unit_test: true do
      expect(pagination.next_page).to eq(3)
    end

    it "can determine the previous page", unit_test: true do
      expect(pagination.previous_page).to eq(1)
    end
    it "can determine the first page", unit_test: true do
      expect(pagination.first_page).to eq(1)
      expect(pagination.first_page?).to be_falsey
    end

    it "can determine the last page", unit_test: true do
      expect(pagination.last_page).to eq(5)
      expect(pagination.last_page?).to be_falsey
    end
  end
end
