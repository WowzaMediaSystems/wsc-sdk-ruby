# Define a model class to use for testing primary key assignment.
#
class PrimaryObjectModel < WscSdk::Model

  model_name_singular :object
  model_name_plural   :objects

  primary_key         :uid

  attribute :id,      :string,  access: :read
  attribute :uid,     :string,  access: :read
  attribute :name,    :string
  attribute :actibe,  :boolean

end
