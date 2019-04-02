####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # A class for handling the pagination data returned by endpoint lists.
  #
  class Pagination
    attr_reader :page, :per_page, :total_pages, :total_records, :page_first_index, :page_last_index

    # Get a new instance of the pagination class.
    #
    # @param pagination_data [Hash] A hash of pagination data
    #
    def initialize(pagination_data={})
      @page               = pagination_data.fetch(:page, 1)
      @per_page           = pagination_data.fetch(:per_page, 1000)
      @total_pages        = pagination_data.fetch(:total_pages, 1)
      @total_records      = pagination_data.fetch(:total_records, -1)
      @page_first_index   = pagination_data.fetch(:page_first_index, -1)
      @page_last_index    = pagination_data.fetch(:page_last_index, -1)
    end

    # Determine if the current page is the first page
    #
    # @return [Boolean] An indication if the current page is the first page.
    #
    def first_page?
      return true if total_pages < 1
      return (page == 1)
    end

    # Get the number of the first page
    #
    # @return [Integer] The number of the first page.
    #
    # @return [Nil] If there is no first page.
    #
    def first_page
      return nil if total_pages < 1
      return 1
    end

    # Get the number of the next page.
    #
    # @return [Integer] The number of the next page
    #
    # @return [Nil] If there are no remaining pages
    #
    def next_page
      return nil if total_pages == -1
      return nil if page == total_pages
      return page + 1
    end

    # Get the number of the previous page.
    #
    # @return [Integer] The number of the previous page
    #
    # @return [Nil] If there are no previous pages
    #
    def previous_page
      return nil if total_pages < 1
      return nil if page == 1
      return page - 1
    end

    # Get the number of the last page
    #
    # @return [Integer] The number of the first page.
    #
    # @return [Nil] If there is no first page.
    #
    def last_page
      return nil if total_pages < 1
      return total_pages
    end

    # Determine if the current page is the last page
    #
    # @return [Boolean] An indication if the current page is the last page.
    #
    def last_page?
      return true if total_pages < 1
      return (page == total_pages)
    end

  end
end
