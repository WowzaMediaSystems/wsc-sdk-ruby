module WscSdk

  # A class to manage lists of models
  #
  class ModelList < Hash
    include WscSdk::ApiResponse

    # Add a model to the list
    #
    # @param model [WscSdk::Model]
    #   The model to add to the list
    #
    def add(model)
      self[model.primary_key] = model
    end

    # Assign pagination data to the list
    #
    # @param pagination [Hash,WscSdk::Pagination]
    #   A hash of pagination options or an instance of WscSdk::Pagination
    #
    def pagination= pagination
      if pagination.is_a?(Hash)
        @pagination = WscSdk::Pagination.new(pagination)
      elsif pagination.is_a?(WscSdk::Pagination)
        @pagination = pagination
      end
    end

    # Get pagination data for the list
    #
    # @return [Hash] A hash of pagination data
    #
    def pagination
      @pagination ||= WscSdk::Pagination.new()
    end
  end

end
