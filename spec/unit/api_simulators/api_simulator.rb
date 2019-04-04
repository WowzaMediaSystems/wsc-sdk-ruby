####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require 'request_interceptor'

class ApiSimulator

  attr_reader   :app
  attr_accessor :models, :current_index

  def initialize
    @current_index  = 1
    @models         = build_models
  end

  def plural_wrapper
    :simulators
  end

  def singular_wrapper
    :simulator
  end

  def default_model
    {}
  end

  def build_models
    {}
  end

  def build_model(data)
    model           = default_model.deep_merge(data || {})
    model[:id]      = "uid#{current_index}"
    @current_index  += 1
    model
  end

  def list
    _list = {}
    _list[plural_wrapper] = @models.map{ |id, value| value }
    _list
  end

  def find(uid)
    _find = {}
    _find[singular_wrapper] = @models[uid.to_sym]
    _find
  end

  def create(data)
    _create = data.deep_symbolize_keys
    _create = _create[singular_wrapper] if _create.has_key?(singular_wrapper)
    _create = build_model(_create)
    _id     = _create[:id]
    @models[_id] = _create
    _create
  end

  def update(data)
    _update = data.deep_symbolize_keys
    _update = _update[singular_wrapper] if _update.has_key?(singular_wrapper)
    _id     = _update[:id]
    @models[_id] = _update
    _update
  end

  def delete(id)
    @models.delete(id)
  end

  def app
    @app ||= RequestInterceptor.define do
      host $simulator_hostname

      # Intercept GET /api/v1.3/transcoders request
      get /\/api\/v1\.3/ do
        content_type "application/json"
        [].to_json
      end
    end
  end
end
