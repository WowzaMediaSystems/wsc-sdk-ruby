####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/helpers/object_model"
require "unit/helpers/action_object_model"

# Define an endpoints class to use for testing.
#
class ObjectEndpoints < WscSdk::Endpoint

  model_class ObjectModel

  model_action :foo,    :get, ActionObjectModel
  model_action :bar,    :put, ActionObjectModel

end


class ObjectActionEndpoints < WscSdk::Endpoint

  model_class ObjectModel

  actions include: [:list, :create, :update], exclude: [:create]

  model_action :foo,    :get, ActionObjectModel
  model_action :bar,    :put, ActionObjectModel

end
