####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

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
