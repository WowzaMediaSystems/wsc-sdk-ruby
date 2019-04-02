module WscSdk

  # A module for defining sets of enumerators and their behaviors.
  #
  module Enums

    # Get a list of values from constants defined in the enum.
    #
    # @return [Array<Any>]
    #   The values defined by the enumerator.
    #
    def values
      _values = []
      self.constants(false).each { |constant| _values << self.const_get(constant) }
      _values
    end


    # Convert a string or symbol into the appropriate constant, and generate
    # an exception otherwise.
    #
    def to_constant(name)
      constant_name = name.to_s.upcase.to_sym
      raise "Model type '#{name.to_s}' doesn't exist" unless self.constants.include?(constant_name)
      return self.const_get("#{self.name}::#{constant_name}")
    end
  end
end
