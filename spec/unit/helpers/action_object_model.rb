# Define a model class for testing endpoint actions.
#
class ActionObjectModel < WscSdk::Model

  model_name_singular :object
  model_name_plural   :objects

  attribute :id,      :string, access: :read
  attribute :name,    :string
  attribute :active,  :boolean

end
