####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'wsc_sdk/modules/api_response'
require 'wsc_sdk/modules/loggable'
require 'wsc_sdk/schema'
require 'wsc_sdk/schema_attribute'

module WscSdk

  # Module for model definitions.
  module Models
  end

  # Base class for defining model schemas and managing inbound/outbound model
  # data.
  #
  class Model
    include WscSdk::ApiResponse
    include WscSdk::Loggable

    # @overload attributes
    #           A hash of attributes and values for the model
    #
    #           *NOTE:* The attributes accessor directly accesses the attributes
    #           for a model.  This is okay for reading data out of a model, but
    #           data assignment should be done using the getter
    #           (model.attribute) and setter (model.attribute=value) methods
    #           that are built into the model.  Otherwise you will be bypassing
    #           the structures necessary to validate the data, which may
    #           generate unwanted outcomes.
    attr_reader :attributes

    # @overload errors
    #           A hash of fields and messages that indicates validation errors
    #           for the model.  Use `model.valid?` if the response is false,
    #           this hash will contain the information necessary to fix the
    #           concerns.
    attr_reader :errors

    # @overload endpoint
    #           The endpoint that generated the model.
    attr_reader :endpoint

    # @overload changes
    #           An array of fields that have changed since the model was last
    #           saved to the API.
    attr_reader :changes

    # @overload partial_data
    #           Determines if the model contains a partial or complete dataset.
    attr_reader :partial_data

    # @overload data_mode
    #           Determines what mode the data is being ingested/accesed in.
    attr_reader :data_mode

    # Create a new model instance.
    #
    # @param endpoint [WscSdk::Endpoint]
    #   The endpoint instance that generated the model.
    #
    # @param attributes [Hash]
    #   A hash of attribute values to assign to the model.
    #
    def initialize(endpoint, attributes={})
      @endpoint     = endpoint
      @changes      = []
      @partial_data = false
      @data_mode    = :access
      initialize_attributes
      ingest_attributes(attributes, write_to_read_only: true, mark_clean: true)
      @errors       = nil
      @dirty        = false
    end


    #---------------------------------------------------------------------------
    #    _  _   _       _ _         _
    #   /_\| |_| |_ _ _(_) |__ _  _| |_ ___ ___
    #  / _ \  _|  _| '_| | '_ \ || |  _/ -_|_-<
    # /_/ \_\__|\__|_| |_|_.__/\_,_|\__\___/__/
    #
    #---------------------------------------------------------------------------

    # Get the current schema definition
    #
    # @return [WscSdk::Schema]
    #
    def schema
      self.class.schema
    end

    # Get the value of the primary key attribute.
    #
    # @return [Any]
    #   The value of the primary key
    #
    def primary_key
      @attributes[self.primary_key_attribute]
    end

    # Get the name of the attribute that represents the primary key of the
    # model.
    #
    # @return [Symbol]
    #   The name of the primary key field.
    #
    def primary_key_attribute
      :id
    end

    # Clear the primary key value.
    #
    # This can be used to create a completely new instance of a model's data
    #
    def clear_primary_key
      @attributes[self.primary_key_attribute] = nil
    end

    # Build the attributes hash from the schema definitions.
    #
    # This is a non-destructive process, so if the attributes are already
    # established and have values, then nothing will happen to them.
    #
    def initialize_attributes()
      @attributes       ||= {}
      merged_attributes = {}
      defaults          = self.class.schema.defaults(self)

      # Merge the defaults in where attributes don't have a value defined.
      defaults.each do |name, value|
        merged_attributes[name] = attributes[name] || value
      end
      @attributes = merged_attributes
    end

    # Load data into the attributes hash and ensure that it meets the
    # requirements of the schema.
    #
    # @param attributes [Hash]
    #   The data to load into the attributes hash.
    #
    # @param options [Hash]
    #   A hash of options
    #
    # @option options [Boolean] :mark_clean
    #   Mark the data as clean after ingesting it.
    #
    # @option options [Boolean] :write_to_read_only
    #   Allow data to be written to read only fields.  This option should only
    #   be used by the model class, and not by users.
    #
    def ingest_attributes(attributes, options={})
      write_to_read_only  = options.fetch(:write_to_read_only,  false)
      mark_clean          = options.fetch(:mark_clean,          false)
      @partial_data       = options.fetch(:partial_data,        false)
      attributes          = (attributes || {}).deep_symbolize_keys
      root_key            = self.class.singular_name.to_sym
      attributes          = attributes.has_key?(root_key) ? attributes[root_key] : attributes

      attributes.each do |attribute, value|
        ingest_attribute(attribute, value, options)
      end
      clean! if mark_clean
    end

    # Load an attribute value into the attributes hash and ensure that it meets
    # the requirements of the schema.
    #
    # @param attribute  [Symbol]
    #   The name of the attribute to ingest
    #
    # @param value      [Any]
    #   The value to ingest into the attribute.
    #
    # @param options [Hash]
    #   A hash of options
    #
    # @option options [Boolean] :write_to_read_only
    #   Allow data to be written to read only fields.  This option should only
    #   be used by the model class, and not by users.
    #
    def ingest_attribute(attribute, value, options={})
      return unless has_attribute?(attribute)

      write_to_read_only  = options.fetch(:write_to_read_only, false)
      attr                = self.class.schema[attribute]
      @data_mode          = write_to_read_only ? :ingest : :access
      _temp_partial_data  = @partial_data
      @partial_data       = false
      set_sym             = "#{attr.attribute_name.to_s}=".to_sym

      self.send(set_sym, value)

      @partial_data       = _temp_partial_data
    end

    # Determines if an attribute names exists in the schema.
    #
    # @param attribute [Symbol]
    #   The name of the attribute to determine the existence of.
    #
    def has_attribute?(attribute)
      attributes.keys.include?(attribute)
    end

    # Cleans out the changes array, which means that the data is no longer
    # marked as dirty.
    #
    def clean!
      @changes = []
    end

    # Determines if the data is dirty or not based on whether changes have been
    # marked in the changes array.
    #
    def dirty?
      @changes.length > 0
    end

    # Allows you to assign a hash of data to the attributes.  This approach
    # uses the ingest pattern to ensure that the data being set is valid before
    # applying it.
    #
    # @param new_attributes [Hash]
    #   A hash of valid, attributes
    #
    def attributes= new_attributes
      ingest_attributes(new_attributes)
    end

    #---------------------------------------------------------------------------
    #  ___ _        _
    # / __| |_ __ _| |_ ___
    # \__ \  _/ _` |  _/ -_)
    # |___/\__\__,_|\__\___|
    #
    #---------------------------------------------------------------------------


    # Determine if the model data is new or not.
    #
    # @return [Boolean]
    #   An indication if the model is new.
    #
    def new_model?
      self.primary_key.nil? or self.primary_key.empty?
    end

    # Determine if the model data is valid and raise an exception if its not.
    #
    # @raise [ArgumentError]
    #   If the model has invalid data.
    #
    def valid!
      raise ArgumentError.new("Invalid attribute values: #{@errors.map{ |f, m| "#{f}: #{m}"}.join(" | ")}") unless valid?
    end

    # Determine if the model data is valid.
    #
    # @return [Boolean]
    #   An indication if the model data is valid.
    #
    def valid?
      validate
      (errors.keys.length == 0)
    end

    # Validate the model data.
    #
    # This will populate the `.errors` hash if data is invalid.
    #
    def validate
      @errors = {}
      self.class.schema.each do |name, attribute|
        value = attribute.value_or_default(self)
        if attribute.required?(self) and value.nil?
          add_error(name, "is required")
        end

        attribute.valid?(self) unless value.nil?
      end
    end

    # Adds an error message to the errors hash.
    #
    # @param attribute [Symbol]
    #   The name of the attribute to add the error to.
    #
    # @param message [String]
    #   The message to add to the error
    #
    def add_error(attribute, message)
      @errors[attribute] ||= []
      @errors[attribute] << message
    end

    # Refresh the data in the model from the API.
    #
    # @return [WscSdk::Model]
    #   A copy of the model if the refresh was successful. An error model if
    #   the refresh was a failure.
    #
    def refresh
      if new_model?
        return WscSdk::Errors.model_does_not_exist(self.endpoint)
      else
        return self.endpoint.refresh(self)
      end
    end

    # Save the data in the model to the api.
    #
    # If the model is new, then the endpoint create method will be called, if
    # the model is not new, then the endpoint update method will be called.
    #
    # @return [WscSdk::Model]
    #   If the created/updated model is valid and returns properly from the
    #   endpoint.
    #
    # @return [Nil]
    #   If the created/updated model is invalid.
    #
    def save
      result = nil
      if new_model?
        result = endpoint.create(self)
        @attributes[self.primary_key_attribute] = result.primary_key if result.success?
      elsif dirty?
        result = endpoint.update(self)
      else
        result = self
      end
      clean! if result.success?
      result
    end

    # Delete the model data from the api.
    #
    # @return [WscSdk::Model]
    #   If the created/updated model is valid and returns properly from the
    #   endpoint.
    #
    # @return [Nil]
    #   If the created/updated model is invalid.
    #
    def delete
      return WscSdk::Errors.model_does_not_exist(self.endpoint) if new_model?
      result = endpoint.delete(self)
      if result.success?
        clean!
        clear_primary_key
        @partial_data = false
      end
      return result
    end

    # Return the success status of the API call that generated this model.
    #
    # @return [Boolean]
    #   An indication of the status of the API call.
    #
    def success?
      return true
    end

    #---------------------------------------------------------------------------
    #    _   ___ ___   ___       _
    #   /_\ | _ \_ _| |   \ __ _| |_ __ _
    #  / _ \|  _/| |  | |) / _` |  _/ _` |
    # /_/ \_\_| |___| |___/\__,_|\__\__,_|
    #
    #---------------------------------------------------------------------------


    # If only a part of the data was requested for the model (e.g. in a list
    # endpoint), then we will request the full data set for the particular
    # object and load the data into the model.
    #
    private def request_remaining_data
      if partial_data
        data_model      = endpoint.find(self.id)
        remaining_data  = data_model.attributes.clone
        ingest_attributes(remaining_data, write_to_read_only: true, mark_clean: true, partial_data: false)
      end
    end

    # Build the request payload, or generate an exception if the data is
    # not valid.
    #
    # @raise [ArgumenError]
    #   If the model has invalid data.
    #
    # @return [Hash]
    #   The properly structure request data.
    #
    def build_payload!
      valid!
      return build_payload
    end

    # Build the request payload.
    #
    # @return [Hash]
    #   The properly structure request data.
    #
    def build_payload
      return nil unless valid?

      model_wrapper = self.class.singular_name.to_sym
      payload       = {}
      wrapper       = payload[model_wrapper] = {}

      self.schema.each do |name, attribute|
        if attribute.write_access?(self)
          value     = attribute.value_or_default(self)
          required  = attribute.required?(self)

          if required or !value.nil?
            wrapper[name] = value
          end
        end
      end

      payload
    end

    #---------------------------------------------------------------------------
    #  __  __
    # |  \/  |__ _ __ _ _ ___ ___
    # | |\/| / _` / _| '_/ _ (_-<
    # |_|  |_\__,_\__|_| \___/__/
    #
    #---------------------------------------------------------------------------


    # Rebuilds the `primary_key_attribute` method in the class to identify an
    # attribute other than the default as the primary key
    #
    # @param [Symbol] attribute_name
    #   The name of the attribute to use as the primary key.
    #
    def self.primary_key(attribute_name)
      define_method :primary_key_attribute do
        return attribute_name.to_sym
      end
    end

    # Builds the `singular_name` static method that will return the name of the
    # model in singular form.
    #
    def self.model_name_singular(wrapper)
      define_singleton_method :singular_name do
        wrapper
      end
    end

    # Builds the `plural_name` static method that will return the name of the
    # model in plural form.
    #
    def self.model_name_plural(wrapper)
      define_singleton_method :plural_name do
        wrapper
      end
    end

    # Defines the default schema structure.
    #
    def self.schema
      Schema.new
    end

    # Defines an attribute in the model schema and establishes the appropriate
    # getters/setters according to its access settings.
    #
    def self.attribute(name, type, options={})
      name            = name.to_sym
      accessor_name   = options.fetch(:as, name).to_sym
      type            = type.to_sym
      current_schema  = self.schema
      attr            = current_schema.add_attribute(name, type, options)

      define_singleton_method :schema do
        current_schema
      end

      define_method accessor_name do
        raise ::NoMethodError.new("the '#{accessor_name}' attribute is not currently readable") unless schema[name].read_access?(self)
        current_value = @attributes[name.to_sym]
        request_remaining_data if (@partial_data and current_value.nil?)
        @attributes[name.to_sym]
      end

      set_sym = "#{accessor_name.to_s}=".to_sym
      define_method(set_sym) do |value|
        not_writable = ((@data_mode == :access) and (!schema[name].write_access?(self)))
        if not_writable
          logger.warn("Attempting to write to non-writable attribute: #{accessor_name}")
          return
        end
        valid_type = self.class.schema.valid_type?(name, value)
        if valid_type
          self.attributes[name] = self.class.schema.transform_value(name, self, value)
          @errors               = nil
          @changes              << name
        else
          logger.warn("The attribute '#{accessor_name.to_s}' expected a(n) #{type} value but got '#{value}' [#{value.class.name}] instead!")
        end
      end

    end

  end
end
