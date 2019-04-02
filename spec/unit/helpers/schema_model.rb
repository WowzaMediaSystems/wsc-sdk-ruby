class SchemaModel < WscSdk::Model

  model_name_singular :schema_object
  model_name_plural   :schema_objects

  attribute :id,                    :string,    access: :read
  attribute :name,                  :string
  attribute :write_only,            :string,    access: :write
  attribute :required_attr,         :string,    required: true
  attribute :required_proc_attr,    :string,    required: Proc.new{ |model| model.is_a?(SchemaModel) }
  attribute :required_symbol_attr,  :string,    required: :is_required
  attribute :validate_array_attr,   :integer,   validate: [1,2,3,4,5]
  attribute :validate_proc_attr,    :integer,   validate: Proc.new { |model|
    valid = model.validate_proc_attr == 2
    model.add_error(:validate_proc_attr, "Dude validate_proc_attr can't be nil") unless valid
    valid
  }
  attribute :validate_symbol_attr,  :integer,   validate: :is_valid
  attribute :access_read_attr,      :boolean,   access: :read
  attribute :access_write_attr,     :boolean,   access: :write
  attribute :default_attr,          :integer,   default: 100
  attribute :default_proc_attr,     :integer,   default: Proc.new{ |model| 80 }
  attribute :default_symbol_attr,   :integer,   default: :determine_default_integer
  attribute :string_attr,           :string
  attribute :boolean_attr,          :boolean
  attribute :integer_attr,          :integer,   default: 1
  attribute :datetime_attr,         :datetime,  default: Time.now
  attribute :some_attr,             :string,    as: :as_attr

  def is_required
    return true
  end

  def is_valid
    valid = self.validate_symbol_attr > 0
    add_error(:validate_symbol_attr, "must be greater than 0") unless valid
    valid
  end

  def determine_default_integer
    60
  end

end
