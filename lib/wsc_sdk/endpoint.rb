####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

module WscSdk

  # Module for endpoint definitions.
  #
  module Endpoints
  end

  # A base class for defining endpoint interactions and generating API requests.
  #
  class Endpoint
    include Loggable

    attr_reader :client, :parent_path

    # Instantiate a new endpoint.
    #
    # @param [WscSdk::Client] client
    #   The client to associate with the endpoint.
    #
    # @param [Hash]           options
    #   A hash of options
    #
    # @option options [String] :parent_path
    #   The parent object path to use when generating endpoint requests.  This
    #   enables chaining models together in the REST pattern.
    #
    def initialize(client, options={})
      @client       = client
      @parent_path  = options.fetch(:parent_path, nil)
    end


    #---------------------------------------------------------------------------
    #    _      _   _
    #   /_\  __| |_(_)___ _ _  ___
    #  / _ \/ _|  _| / _ \ ' \(_-<
    # /_/ \_\__|\__|_\___/_||_/__/
    #
    #---------------------------------------------------------------------------

    # List all of the models for the endpoint.
    #
    # @param options [Hash]
    #   A hash of options
    #
    # @option options [Hash] :pagination
    #   Pagination configuration for the returned list.
    #
    # @option options [Hash] :filters
    #   Filters to be applied to the list.
    #
    # @return [Hash<Any,WscSdk::Model>]
    #   A hash of the models in the list, keyed by their primary key.
    #
    # @return [WscSdk::Models::Error]
    #   An error response if the request failed.
    #
    def list(options={})
      url             = list_path
      response        = client.get(url, options)

      if (200..299).include?(response.code)
        return transform_list(response.body)
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end

    # Find a specific model in the endpoint.
    #
    # @param id [Any]
    #   The id/primary key of the model to find.
    #
    def find(id)
      response    = client.get(find_path(id))
      if (200..299).include?(response.code)
        return transform_model(response.body)
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end

    # Refresh the data of a specific model.
    #
    # @param model [WscSdk::Model]
    #
    def refresh(model)
      response    = client.get(find_path(model.primary_key))
      if (200..299).include?(response.code)
        return transform_model(response.body, origin_model: model)
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end

    # Build a new instance of the model class, without committing it to the API.
    #
    # @param attributes [Hash]
    #   A hash of attributes to assign to the new instance.
    #
    # @return [WscSdk::Model]
    #   The new instance of the model.
    #
    def build(attributes={})
      self.class.model.new(self, attributes)
    end

    # Create a new model using the endpoint.
    #
    # If successful this method will directly modify the model_object that is
    # provided, and also return a reference to that object.
    #
    # If the data in the model_object is not valid, then the validation messages
    # will be updated in the errors property, and the method will return a Nil
    # object.
    #
    # @param model_object [WscSdk::Model]
    #   The model object to create in the endpoint.
    #
    # @return [WscSdk::Model]
    #   If the newly created model is valid and returns properly from the
    #   endpoint.
    #
    # @return [Nil]
    #   If the newly created model is invalid.
    #
    def create(model_object)
      return WscSdk::Errors.model_exists(self) unless model_object.new_model?

      payload   = model_object.build_payload
      return WscSdk::Errors.invalid_attributes(self) unless model_object.valid?

      response  = client.post(create_path, body: payload)

      if (200..299).include?(response.code)
        return transform_model(response.body, origin_model: model_object)
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end

    # Update an existing model in the endpoint.
    #
    # If the model_object's `WscSdk::Model#new_model?` call returns true, this
    # method becomes an alias for `WscSdk::Model#create(model_object)`
    #
    # If successful this method will directly modify the model_object that is
    # provided, and also return a reference to that object.
    #
    # If the data in the model_object is not valid, then the validation messages
    # will be updated in the errors property, and the method will return a Nil
    # object.
    #
    # @param model_object [WscSdk::Model]
    #   The model object to create in the endpoint.
    #
    # @return [WscSdk::Model]
    #   If the newly created model is valid and returns properly from the
    #   endpoint.
    #
    # @return [Nil]
    #   If the newly created model is invalid.
    #
    def update(model_object)
      return WscSdk::Errors.model_does_not_exist(self) if model_object.new_model?

      payload   = model_object.build_payload
      return WscSdk::Errors.invalid_attributes(self) unless model_object.valid?

      response  = client.put(update_path(model_object.primary_key), body: payload)
      if (200..299).include?(response.code)
        return transform_model(response.body, origin_model: model_object)
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end

    # Delete an existing model in the endpoint.
    #
    # If the model_object's `WscSdk::Model#new_model?` call returns true, this
    # method becomes an alias for `WscSdk::Model#create(model_object)`
    #
    # If successful this method will directly modify the model_object that is
    # provided, and also return a reference to that object.
    #
    # If the data in the model_object is not valid, then the validation messages
    # will be updated in the errors property, and the method will return a Nil
    # object.
    #
    # @param model_object [WscSdk::Model]
    #   The model object to create in the endpoint.
    #
    # @return [WscSdk::Model]
    #   If the newly created model is valid and returns properly from the
    #   endpoint.
    #
    # @return [Nil]
    #   If the newly created model is invalid.
    #
    def delete(model_object)
      return WscSdk::Errors.model_does_not_exist(self) if model_object.new_model?

      response  = client.delete(delete_path(model_object.primary_key))
      if (200..299).include?(response.code)
        model_object.clear_primary_key
        return model_object
      else
        return transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end


    #---------------------------------------------------------------------------
    #  ___      _   _
    # | _ \__ _| |_| |_  ___
    # |  _/ _` |  _| ' \(_-<
    # |_| \__,_|\__|_||_/__/
    #
    #---------------------------------------------------------------------------

    # Get the path for the list of models
    #
    # @return [String]
    #   The list path.
    #
    def list_path
      [ parent_path, model_name_plural ].compact.join("/")
    end

    # Get the path for an individual model.
    #
    # @param id [Any]
    #   The unique id of the model.
    #
    # @return [String]
    #   The model path.
    #
    def model_path(id)
      [ parent_path, model_name_plural, id ].compact.join("/")
    end

    # Get the path for finding an individual model
    #
    # @param id [Any]
    #   The unique id of the model.
    #
    # @return [String]
    #   The find path.
    #
    def find_path(id)
      model_path(id)
    end

    # Get the path for creating an individual model
    #
    # @return [String]
    #   The create path.
    #
    def create_path
      list_path
    end

    # Get the path for updating an individual model
    #
    # @param id [Any]
    #   The unique id of the model.
    #
    # @return [String]
    #   The update path.
    #
    def update_path(id)
      model_path(id)
    end

    # Get the path for deleting an individual model
    #
    # @param id [Any]
    #   The unique id of the model.
    #
    # @return [String]
    #   The destroy path.
    #
    def delete_path(id)
      model_path(id)
    end


    #---------------------------------------------------------------------------
    #  __  __         _     _   _  _              _ _ _
    # |  \/  |___  __| |___| | | || |__ _ _ _  __| | (_)_ _  __ _
    # | |\/| / _ \/ _` / -_) | | __ / _` | ' \/ _` | | | ' \/ _` |
    # |_|  |_\___/\__,_\___|_| |_||_\__,_|_||_\__,_|_|_|_||_\__, |
    #                                                       |___/
    #---------------------------------------------------------------------------

    # Get the plural form of the model name.
    #
    # @return [String]
    #   The plural form of the model name.
    #
    def model_name_plural
      return nil if self.class.model.nil?
      self.class.model.plural_name
    end

    # Get the singular form of the model name
    #
    # @return [String]
    #   The singular form of the model name
    #
    def model_name_singular
      return nil if self.class.model.nil?
      self.class.model.singular_name
    end


    # Transform a response payload into a list of models.
    #
    # @param payload [Hash]
    #   The response payload from an API request.
    #
    # @return [WscSdk::ModelList]
    #   The list of models
    #
    def transform_list(payload)
      list = WscSdk::ModelList.new
      begin
        data    = JSON.parse(payload).deep_symbolize_keys

        data[model_name_plural.to_sym].each do |model_data|
          model = self.class.model.new(self)
          model.ingest_attributes(model_data, write_to_read_only: true, mark_clean: true, partial_data: true)
          list.add(model)
        end

        list.pagination = data[:pagination] if data.has_key?(:pagination)

        return list
      rescue JSON::ParserError => e
        return handle_json_error(e, payload)
      end
    end

    # Transform a response payload into a model.
    #
    # @param payload [String]
    #   The response body from an API request.
    #
    # @param options [Hash]
    #   A hash of options
    #
    # @option options [WscSdk::Model] :model_class
    #   The class of the model to transform the payload into.  This is set to
    #   then endpoints static `Endpoint#model` class that is assigned when the
    #   endpoint is built. This option is overridden if the `:origin_model`
    #   option is used.
    #
    # @option options [WscSdk::Model] :origin_model
    #   An existing model that is used instead of generating a new one.  This
    #   model needs to be the same type of model that is represented by the
    #   payload otherwise errors may be generated.  This options overrides the
    #   `:model_class` options if it's set.
    #
    # @return [WscSdk::Model]
    #   The model
    #
    def transform_model(payload, options={})
      model_class   = options.fetch(:model_class, self.class.model)
      origin_model  = options.fetch(:origin_model, nil)
      model         = nil

      begin
        data              = JSON.parse(payload).deep_symbolize_keys
        model             = origin_model.nil? ? model_class.new(self) : origin_model
        root_key          = model.class.singular_name.to_sym
        model_data        = data.has_key?(root_key) ? data[root_key] : data

        model.ingest_attributes(model_data, write_to_read_only: true, mark_clean: true)

        return model
      rescue JSON::ParserError => e
        return handle_json_error(e, payload)
      end
    end

    # If there is an error while attempting to parse inbound JSON, then make
    # sure we have a uniform response mechanism.
    #
    # A logger error message is written with the error message.
    # A logger debug message is written with the payload information.
    # A WscSdk::Models::Error object is returned
    #
    # @param json_error (JSON::ParserError)
    #   The exception raised while parsing the JSON
    #
    # @param payload (String)
    #   (nil) If a payload is available, then we will log the details at a DEBUG
    #   level.
    #
    # @raise [WscSdk::Model::Error]
    #   Returns an error model so that the SDK can continue without interruption
    #   but details will be available, and the `.success?` test will fail.
    #
    def handle_json_error(json_error, payload=nil)
      client.logger.error("Payload Invalid : #{json_error.message}")
      client.logger.debug("Payload Data    : #{payload}") if payload
      return WscSdk::Errors.invalid_payload(self)
    end

    #---------------------------------------------------------------------------
    #  __  __
    # |  \/  |__ _ __ _ _ ___ ___
    # | |\/| / _` / _| '_/ _ (_-<
    # |_|  |_\__,_\__|_| \___/__/
    #---------------------------------------------------------------------------

    # Define which built-in actions should be available in the endpoint.
    #
    # @param [Hash] config
    #   A hash of configuration options
    #
    # @option config [Array] :include
    #   An array of actions to keep enabled, anything not listed will be
    #   disabled.
    #
    # @option config [Array] :exclude
    #   An array of actions to disable. This option supercedes the :include
    #   option.
    #
    def self.actions config={}
      available_actions = [:list, :find, :build, :create, :update, :delete]
      disabled_actions  = available_actions.clone

      include_actions   = config.fetch(:include, [])
      include_actions   = [include_actions] unless include_actions.is_a?(Array)
      include_actions   = include_actions.map{ |action| action.to_sym }

      exclude_actions   = config.fetch(:exclude, [])
      exclude_actions   = [exclude_actions] unless include_actions.is_a?(Array)
      exclude_actions   = exclude_actions.map{ |action| action.to_sym }

      # Do the math to determine which actions should be disabled
      disabled_actions  = ((disabled_actions - include_actions) + exclude_actions).flatten.compact

      # Get the intersectino of the available actions and the disabled actions
      # to make sure that we aren't disabling unexpected actions.
      disabled_actions  = available_actions & disabled_actions

      disabled_actions.each do |disabled_action|
        define_method disabled_action.to_sym do |*args|
          raise NoMethodError.new("the '#{disabled_action}' action is not enabled on this endpoint")
        end
      end
    end

    # Builds the `model` static method that returns the class of the expected
    # model for the given endpoint.
    #
    # @param model_class [Class]
    #   The class of the expected model.
    #
    def self.model_class model_class
      define_singleton_method :model do
        model_class
      end
    end

    # Builds additional action methods for the given model into the endpoint.
    # this allows the endpoint functionality to be extended.
    #
    # @param action_name  [Symbol]
    #   The name of the action to append to the endpoint path (e.g. /start)
    #
    # @param method       [Symbol]
    #   The request action method (:get, :post, :put, :patch, :delete)
    #
    # @param model_class  [Class]
    #   The expected model class that is retuned by the action.
    #
    def self.model_action(action_name, method, model_class)
      define_method action_name.to_sym do |id|
        response    = self.client.send(method.to_sym, [find_path(id), action_name.to_s].join("/"))
        (200..299).include?(response.code) ?
          transform_model(response.body, model_class: model_class) :
          transform_model(response.body, model_class: WscSdk::Models::Error)
      end
    end
  end
end
