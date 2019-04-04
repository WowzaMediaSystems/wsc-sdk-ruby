####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

# Define a model class for testing endpoint actions.
#
class ActionObjectModel < WscSdk::Model

  model_name_singular :object
  model_name_plural   :objects

  attribute :id,      :string, access: :read
  attribute :name,    :string
  attribute :active,  :boolean

end
