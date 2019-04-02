# Define a model class for use in testing.
#
class ObjectModel < WscSdk::Model

  model_name_singular :object
  model_name_plural   :objects

  attribute :id,            :string,    access: :read
  attribute :name,          :string
  attribute :write_only,    :string,    access: :write
  attribute :read_only,     :string,    access: :read
  attribute :ingest_test,   :string,    access: :read, default: "not ingested"
  attribute :count,         :integer
  attribute :active,        :boolean
  attribute :numbers,       :array
  attribute :default_int,   :integer,   default: 0
  attribute :default_str,   :string,    default: "test"
  attribute :validate_str,  :string,    default: "valid", validate: :validate_the_string
  attribute :created_at,    :datetime,  access: :read
  attribute :updated_at,    :datetime,  access: :read


  def validate_the_string
    valid = !validate_str.nil?
    self.add_error(:validate_str, "must not be nil") unless valid
    valid
  end
end
