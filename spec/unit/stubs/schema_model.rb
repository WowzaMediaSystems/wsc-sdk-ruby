####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

base_path = "http://#{$simulator_hostname}/api/#{WscSdk::PATH_VERSION}"

stub_objects = [
  {
    id:                   "abcd1234",
    name:                 "Test Schema Model",
    required_attr:        "This is required",           # :string,    required: true
    required_proc_attr:   "This is required by Proc",   # :string,    required: Proc.new{ |model| model.is_a?(SchemaObjectModel) }
    required_symbol_attr: "This is required by Symbol", # :string,    required: :is_required
    validate_array_attr:  1,                            # :integer,   validate: [1,2,3,4,5]
    validate_proc_attr:   2,                            # :integer,   validate: Proc.new{ |model, attribute, value| return value.nil? ? "Dude #{attribute} can't be nil" : nil }
    validate_symbol_attr: 3,                            # :integer,   validate: :is_valid
    access_read_attr:     true,                         # :boolean,   access: :read
    access_write_attr:    false,                        # :boolean,   access: :write
    string_attr:          "This is a string",           # :string
    boolean_attr:         true,                         # :boolean
    integer_attr:         2
  }
]

load_stubs([
  {
    name: "List Schema Objects",
    url: "#{base_path}/schema_objects",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: stub_objects
      }
    }
  },

  {
    name: "Find Schema Object 1",
    url: "#{base_path}/schema_objects/abcd1234",
    method: :get,
    response: {
      status: 200,
      body: {
        object: stub_objects[0]
      }
    }
  },

  {
    name: "Create Schema Object 1",
    url: "#{base_path}/schema_objects",
    method: :post,
    response: {
      status: 200,
      body: {
        object: stub_objects[0]
      }
    }
  },

  {
    name: "Update Schema Object 1",
    url: "#{base_path}/schema_objects",
    method: :put,
    response: {
      status: 200,
      body: {
        object: stub_objects[0]
      }
    }
  }

])
