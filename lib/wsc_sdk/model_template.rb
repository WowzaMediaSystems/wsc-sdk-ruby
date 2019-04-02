module WscSdk

  # A module that contains the various templates
  module Templates

  end

  # A base class for the model templates.
  #
  class ModelTemplate

    # Modifies a hash with a hash of modifiers
    #
    # @param [Hash] data
    #   The initial hash to be modified
    #
    # @param [Hash] modifiers
    #   A hash of modifiers for the final template output.
    #
    def self.merge(data, modifiers)
      data.deep_merge(modifiers)
    end
  end
end
