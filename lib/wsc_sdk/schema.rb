####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # A class that manages the data schema for an SDK model.
  #
  class Schema < Hash


    # Adds an attribute to the schema
    #
    # @param name [Symbol]
    #   The name of the attribute.
    #
    # @param type [Symbol]
    #   The type of the attribute.  The type must be in the list of
    #   WscSdk::SchemaAttribute::TYPES
    #
    # @param options [Hash]
    #   A hash of options
    #
    # @option options [Any,Proc,Symbol] :default
    #   The default value of the attribute.  This value must match the assigned
    #   type of the attribute.  The default value can be determined by a direct
    #   value, a Proc or a Symbol that represents a method in the model.
    #
    #   If a *Proc* is provided it will be passed an instance of the model, which
    #   can be used to determine the default value for the attribute.  The Proc
    #   should return a value that is the same type as the attribute.
    #
    #   If a *Symbol* is provided, the Symbol will be checked against the model
    #   to determine if there is a method available that has the same name.  If
    #   one exists, that method will be passed an instance of the model, which
    #   can be used to determine the default value for the attribute.  The
    #   method should return a value that is the same type as the attribute. If
    #   no method is found that matches the symbol, the symbol itself is used
    #   as the default.
    #
    # @option options [Array,Proc,Symbol] :required
    #   Determines if the attribute is required.
    #
    #   If a *Proc* is provided it will be passed an instance of the model, which
    #   can be used to determine if the value is required.  The Proc should
    #   return a boolean value.
    #
    #   If a *Symbol* is provided, the Symbol will be checked against the model
    #   to determine if there is a method available that has the same name.  If
    #   one exists, that method will be called.  The method should return a
    #   boolean value.
    #
    # @option options [Array,Proc,Symbol] :validate
    #   Determines if the attribute is valid.
    #
    #   If a *Proc* is provided it will be passed an instance of the model, which
    #   can be used to determine if the value is valid.  The Proc should return
    #   a string describing why the attribute is not valid, otherwise it should
    #   return nil.
    #
    #   If a *Symbol* is provided, the Symbol will be checked against the model to
    #   determine if there is a method available that has the same name.  If one
    #   exists, that method will be passed an instance of the model, which
    #   can be used to determine if the value is valid.  The Proc should return
    #   a string describing why the attribute is not valid, otherwise it should
    #   return nil.
    #
    # @raise [ArgumentError]
    #   If the type is not in the WscSdk::SchemaAttribute::TYPES list.
    #
    # @raise [IndexError]
    #   If the attribute name is already defined in the schema.
    #
    def add_attribute(name, type, options={})
      name = name.to_sym
      raise IndexError.new("The attribute `#{name}` is already defined in the schema") if has_key?(name)
      self[name] = SchemaAttribute.new(name, type, options)
    end

    # Determines if the value is a valid type for the attribute.
    #
    # @param [Symbol] attribute
    #   The attribute to validate the value for.
    #
    # @param [Any] value
    #   The value to validate
    #
    # @return [Boolean]
    #   An indication if the value is valid.
    #
    def valid_type?(attribute, value)
      return false unless has_attribute?(attribute)
      self[attribute].valid_type?(value)
    end

    # Transforms a value into the appropriate type.
    #
    # @param [Symbol] attribute
    #   The attribute to validate the value for.
    #
    # @param [WscSdk::Model] model
    #   The model to transform the value for.
    #
    # @param [Any] value
    #   The value to validate
    #
    # @return [Any]
    #   The transformed value.
    #
    def transform_value(attribute, model, value)
      return nil unless has_attribute?(attribute)
      self[attribute].transform_value(model, value)
    end

    # Determine if the schema has an attribute
    #
    # @param attribute [Symbol]
    #   The name of the attribute
    #
    def has_attribute?(attribute)
      has_key?(attribute)
    end

    # Generates a hash of default values for the given model.
    #
    # This is a non-destructive process, so if the attributes are already
    # established and have values, then nothing will happen to them.
    #
    # @param model [WscSdk::Model]
    #   The model to use to determine the default values in the event that they
    #   are defined as a Proc or a Symbol.
    #
    def defaults(model)
      hsh = {}
      each do |name, attribute|
        hsh[name] = attribute.default_value(model)
      end
      hsh
    end
  end
end
