####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # A class to represent an attribute inside of a model's data schema.
  #
  class SchemaAttribute

    # A list of valid types for a schema attribute
    TYPES = [
      :string,
      :integer,
      :float,
      :boolean,
      :array,
      :hash,
      :datetime
    ]

    attr_reader :name, :type, :access, :default, :validate, :required, :as

    # Create a new schema attribute.
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
    def initialize(name, type, options={})
      raise ArgumentError.new("Invalid schema attribute type specified: #{type}") unless valid_type?(type)
      @name       = name.to_sym
      @type       = type
      @access     = options.fetch(:access,    :read_write)
      @default    = options.fetch(:default,   nil)
      @required   = options.fetch(:required,  false)
      @validate   = options.fetch(:validate,  nil)
      @as         = options.fetch(:as,        nil)
    end

    # Returns the expected attribute name for the attribute.  If the `as` value
    # is returned, this is returned, otherwise the attributes `name` value is
    # returned.
    #
    # @return [Symbol]
    #   The `as` or `name` value for the attribute
    #
    def attribute_name
      (self.as || self.name).to_sym
    end

    # Determine if the attribute is readable according to the attribute
    # configuration.
    #
    # @param model [WscSdk::Model]
    #   The model that will determine the access level of the attribute.
    #
    # @return [Boolean]
    #   An indication if this attribute is readable by the model.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def read_access?(model)
      return true if access.nil?
      raise ::ArgumentError.new("The provided #{model.class.name} model does not have the #{self.name} attribute configured") unless model.has_attribute?(self.name)

      current_access = call_proc_or_symbol(access, model)
      [:read, :read_write].include?(current_access)
    end

    # Determine if the attribute is writable according to the attribute
    # configuration.
    #
    # @param model [WscSdk::Model]
    #   The model that will determine the access level of the attribute.
    #
    # @return [Boolean]
    #   An indication if this attribute is writable by the model.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def write_access?(model)
      return true if access.nil?
      raise ArugumentError.new("The provided #{model.class.name} model does not have the #{self.name} attribute configured") unless model.has_attribute?(self.name)

      current_access = call_proc_or_symbol(access, model)
      [:write, :read_write].include?(current_access)
    end

    # Determine if a value is valid according to the attribute configuration.
    #
    # @param model [WscSdk::Model]
    #   The model the value comes from.
    #
    # @return [String]
    #   A message of what's wrong if the value isn't valid, or nil if the value
    #   is valid.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def valid?(model)
      return nil if validate.nil?

      raise ArugumentError.new("The provided #{model.class.name} model does not have the #{self.name} attribute configured") unless model.has_attribute?(self.name)
      value = model.attributes[self.name]

      message = nil

      if validate.is_a?(Array)
        valid   = validate.include?(value)
        model.add_error(name, "value must be one of the following: #{validate.join(", ")}")  unless valid
        return valid
      else
        return call_proc_or_symbol(validate, model)
      end

      # Calls should never get here.
      return true
    end

    # Determines if the specified type of the attribute is valid.
    #
    # @param [Symbol] attribute_type
    #   The type to check if it's valid.
    #
    # @return [Boolean]
    #   An indication that the type is valid.
    #
    def valid_type?(attribute_type)
      return true if TYPES.include?(attribute_type)
      return valid_model_type?(attribute_type)
    end

    # Determines if the specified type of the attribute matches a model.
    #
    # @param [Symbol] attribute_type
    #   The type to check if it's valid.
    #
    # @return [Boolean]
    #   An indication that the type represents a model.
    #
    def valid_model_type?(attribute_type)
      type_class = type_to_class(attribute_type)
      !type_class.nil?
    end

    # Converts the specified type to a class
    #
    # @param [Symbol] attribute_type
    #   The type to check if it's valid.
    #
    # @return [Any]
    #   The class represented by the type, or nil if it's not a valid type.
    #
    def type_to_class(attribute_type)
      # Booleans are a special case because they are not represented by a single
      # class.
      return String if attribute_type == :boolean
      return Time   if attribute_type == :datetime

      class_name = attribute_type.to_s.camelize
      unless TYPES.include?(attribute_type)
        class_name  = "WscSdk::Models::#{class_name}"
      end
      return (class_name.constantize)
    end

    # Converts an inbound value to the appropriate type.
    #
    # @param [WscSdk::Model] model
    #   The model the value is for.
    #
    # @param [Any] value
    #   The value to be transformed
    #
    # @return [Any]
    #   The transformed value
    #
    def transform_value(model, value)

      # Booleans are a special case because they are not represented by a single
      # class.
      return value.to_s.downcase.start_with?("y","t","1") if self.type == :boolean
      type_class        = type_to_class(self.type)
      transformed_value = value

      if type_class == Time
        current_timezone = Time.zone
        Time.zone = "UTC"
        transformed_value = Time.zone.parse(value) # => Tue, 23 Nov 2010 23:29:57 UTC +00:00
        Time.zone = current_timezone
      elsif type_class < WscSdk::Model and value.is_a?(Hash)
        transformed_value = type_class.new(model.endpoint, value)
      end
      transformed_value
    end

    # Returns the default value for the attribute
    #
    # @param model [WscSdk::Model]
    #   The model the value comes from.
    #
    def default_value(model)
      call_proc_or_symbol(default, model)
    end

    # Return either the value from the model that is represented by the
    # attribute, or the default value if the value is not assigned.
    #
    # @param model [WscSdk::Model]
    #   The model the value comes from.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def value_or_default(model)
      raise ArugumentError.new("The provided #{model.class.name} model does not have the #{self.name} attribute configured") unless model.has_attribute?(self.name)
      model.attributes[self.name] || default_value(model)
    end

    # Determine if the attribute is required.
    #
    # @param model [WscSdk::Model]
    #   The model the value comes from.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def required?(model)
      raise ArugumentError.new("The provided #{model.class.name} model does not have the #{self.name} attribute configured") unless model.has_attribute?(self.name)
      return required if required.is_a?(TrueClass) or required.is_a?(FalseClass)
      _required = call_proc_or_symbol(required, model)
      return false if _required.nil?
      _required
    end

    # Call a Proc or Symbol against a model.
    #
    # @param proc_or_symbol [Proc,Symbol]
    #   The Proc or Symbol to attempt to make a call against.  If the value
    #   provided is Nil, or not a Proc or Symbol, then it is returned directly.
    #
    # @param model [WscSdk::Model]
    #   The model to pass into the Proc or Symbol method if appropriate.
    #
    # @return [Any]
    #   The results of calling the Proc or Symbol or the value of proc_or_symbol
    #   if it isn't a Proc or Symbol.
    #
    # @raise [ArgumentError]
    #   If the provided model does not have this attribute configured.
    #
    def call_proc_or_symbol(proc_or_symbol, model)
      return proc_or_symbol if proc_or_symbol.nil?
      return proc_or_symbol.call(model) if proc_or_symbol.is_a?(Proc)
      return model.send(proc_or_symbol) if proc_or_symbol.is_a?(Symbol) and model.respond_to?(proc_or_symbol)
      return proc_or_symbol
    end

    # Determine if the provided value is of a valid type for the attribute.
    #
    # @param value [Any]
    #   The value whose type will be compared to the attribute to determine if
    #   it is valid.
    #
    # @return [Boolean]
    #   An indication of whether or not the value's type matches the attribute
    #   type.
    #
    def valid_type?(value)
      return true if value.nil?

      valid = case (type)
      when :string
        value.is_a?(String)
      when :integer
        value.is_a?(Integer) or (value.to_i.to_s == value.to_s)
      when :float
        value.is_a?(Float) or (value.to_f.to_s == value.to_s)
      when :boolean
        value.is_a?(TrueClass) or value.is_a?(FalseClass) or ['0','1','y','n','t','f','true','false'].include?(value.to_s.downcase)
      when :array
        value.is_a?(Array)
      when :hash
        value.is_a?(Hash)
      when :datetime
        value.is_a?(Date) or value.is_a?(Time) or (!(Date.parse(value) rescue nil).nil?)
      else
        true
      end
    end

  end
end
