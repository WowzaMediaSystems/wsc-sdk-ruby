####> This code and all components © 2015 – 2019 Wowza Media Systems, LLC. All rights reserved.
####> This code is licensed pursuant to the BSD 3-Clause License.

require "unit/spec_helper"
require "unit/webmock_helper"
require "unit/helpers/object_endpoints"
require "unit/helpers/primary_object_model"
require "unit/stubs/object_model"

describe WscSdk::Endpoint do

  let(:client)      { WscSdk::Client.new }

  it "can initialize properly", unit_test: true do
    endpoint = ObjectEndpoints.new(client)
  end

  context "Endpoint behaviors" do

    let(:endpoint) { endpoint = ObjectEndpoints.new(client) }
    let(:endpoint_with_parent) { endpoint = ObjectEndpoints.new(client, parent_path: "parent/1") }

    it "can list objects", unit_test: true do
      puts "Endpoint List Path: #{endpoint.list_path}"
      object_list = endpoint.list

      expect(object_list.keys.length).to eq(2)

      object_1 = object_list[object_list.keys[0]]
      expect(object_1.primary_key).to eq("abcd1234")
      expect(object_1.id).to eq("abcd1234")
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")

      object_2 = object_list[object_list.keys[1]]
      expect(object_2.primary_key).to eq("efgh5678")
      expect(object_2.id).to eq("efgh5678")
      expect(object_2.name).to eq("Object #2")
      expect(object_2.count).to eq(8)
      expect(object_2.active).to eq(false)
      expect(object_2.numbers).to eq([6,7,8,9])
      expect(object_2.created_at).to eq("2019-02-23 00:00:00")
      expect(object_2.updated_at).to eq("2019-02-23 00:00:00")
    end

    it "can list objects with pagination", unit_test: true do
      object_list = endpoint.list(pagination: { page: 1, per_page: 1 })
      expect(object_list.keys.length).to eq(1)

      object_1 = object_list[object_list.keys[0]]
      expect(object_1.primary_key).to eq("abcd1234")
      expect(object_1.id).to eq("abcd1234")
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")


      object_list = endpoint.list(pagination: { page: 2, per_page: 1 })
      expect(object_list.keys.length).to eq(1)

      object_1 = object_list[object_list.keys[0]]
      expect(object_1.primary_key).to eq("efgh5678")
      expect(object_1.id).to eq("efgh5678")
      expect(object_1.name).to eq("Object #2")
      expect(object_1.count).to eq(8)
      expect(object_1.active).to eq(false)
      expect(object_1.numbers).to eq([6,7,8,9])
      expect(object_1.created_at).to eq("2019-02-23 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-23 00:00:00")
    end

    it "can list objects with filters", unit_test: true do
      object_list = endpoint.list(filters: { foo: "bar" })
      expect(object_list.keys.length).to eq(1)

      object_1 = object_list[object_list.keys[0]]
      expect(object_1.primary_key).to eq("abcd1234")
      expect(object_1.id).to eq("abcd1234")
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")
    end

    it "can list objects with extram params", unit_test: true do
      object_list = endpoint.list(params: { foo: "bar" })
      expect(object_list.keys.length).to eq(1)

      object_1 = object_list[object_list.keys[0]]
      expect(object_1.primary_key).to eq("abcd1234")
      expect(object_1.id).to eq("abcd1234")
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")
    end

    it "can find an object", unit_test: true do
      object_1 = endpoint.find("abcd1234")
      expect(object_1.primary_key).to eq("abcd1234")
      expect(object_1.id).to eq("abcd1234")
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")

      object_2 = endpoint.find("efgh5678")
      expect(object_2.primary_key).to eq("efgh5678")
      expect(object_2.id).to eq("efgh5678")
      expect(object_2.name).to eq("Object #2")
      expect(object_2.count).to eq(8)
      expect(object_2.active).to eq(false)
      expect(object_2.numbers).to eq([6,7,8,9])
      expect(object_2.created_at).to eq("2019-02-23 00:00:00")
      expect(object_2.updated_at).to eq("2019-02-23 00:00:00")
    end

    it "can build a new instance of an object", unit_test: true do
      new_object = endpoint.build()
      expect(new_object.class).to eq(ObjectModel)
      expect(new_object.new_model?).to be_truthy
    end

    it "can create an object", unit_test: true do
      new_object = endpoint.build()
      expect(new_object.class).to eq(ObjectModel)
      expect(new_object.new_model?).to be_truthy

      expect(endpoint.create(new_object).success?).to be_truthy
      expect(new_object.new_model?).to be_falsey
      expect(new_object.id).to eq("wxyz9876")
      expect(new_object.name).to eq("Object #3")
      expect(new_object.count).to eq(99)
      expect(new_object.active).to eq(true)
      expect(new_object.numbers).to eq([1,2])
      expect(new_object.created_at).to eq("2019-02-26 00:00:00")
      expect(new_object.updated_at).to eq("2019-02-26 00:00:00")
    end

    it "can update an object", unit_test: true do
      object_1 = endpoint.find('abcd1234')

      object_1.name     = "Updated Object #1"
      object_1.count    = 5
      object_1.active   = false
      object_1.numbers  = [3,4,5]

      expect(endpoint.update(object_1).success?).to be_truthy
      expect(object_1.name).to eq("Updated Object #1")
      expect(object_1.count).to eq(5)
      expect(object_1.active).to eq(false)
      expect(object_1.numbers).to eq([3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-27 00:00:00")
    end

    it "can refresh an object", unit_test: true do
      object_1 = endpoint.find("abcd1234")
      object_1.name = "This is bad data"

      expect(endpoint.refresh(object_1).success?).to be_truthy
      expect(object_1.name).to eq("Object #1")
    end

    it "can delete an object", unit_test: true do
      object_1 = endpoint.find("abcd1234")

      expect(endpoint.delete(object_1).success?).to be_truthy
      expect(object_1.new_model?).to be_truthy
      expect(object_1.name).to eq("Object #1")
      expect(object_1.count).to eq(4)
      expect(object_1.active).to eq(true)
      expect(object_1.numbers).to eq([1,2,3,4,5])
      expect(object_1.created_at).to eq("2019-02-24 00:00:00")
      expect(object_1.updated_at).to eq("2019-02-24 00:00:00")
    end

    it "can generate a list request path", unit_test: true do
      expect(endpoint.list_path).to eq("objects")
      expect(endpoint_with_parent.list_path).to eq("parent/1/objects")
    end

    it "can generate model request path", unit_test: true do
      expect(endpoint.model_path(2)).to eq("objects/2")
      expect(endpoint_with_parent.model_path(2)).to eq("parent/1/objects/2")
    end

    it "can generate a model find path", unit_test: true do
      expect(endpoint.find_path(2)).to eq("objects/2")
      expect(endpoint_with_parent.find_path(2)).to eq("parent/1/objects/2")
    end

    it "can generate a model update path", unit_test: true do
      expect(endpoint.update_path(2)).to eq("objects/2")
      expect(endpoint_with_parent.update_path(2)).to eq("parent/1/objects/2")
    end

    it "can generate a model delete path", unit_test: true do
      expect(endpoint.delete_path(2)).to eq("objects/2")
      expect(endpoint_with_parent.delete_path(2)).to eq("parent/1/objects/2")
    end

    it "will return a pluralized model name", unit_test: true do
      expect(endpoint.model_name_plural).to eq(:objects)
    end

    it "will return a singular model name", unit_test: true do
      expect(endpoint.model_name_singular).to eq(:object)
    end

    context "Action Management" do

      let(:endpoint_actions) { endpoint = ObjectActionEndpoints.new(client) }

      it "can include actions", unit_test: true do
        object_1 = endpoint.find('abcd1234')
        expect{ endpoint_actions.list }.not_to raise_error(Exception)
        expect{ endpoint_actions.update(object_1) }.not_to raise_error(Exception)
      end

      it "can exclude actions", unit_test: true do
        object_1 = endpoint.find('abcd1234')
        expect{ endpoint_actions.delete }.to raise_error(Exception)
        expect{ endpoint_actions.create(object_1) }.to raise_error(Exception)
      end
    end

    context "Payload Transformation" do
      let(:model_data) {
        {
          id:           "abcd1234",
          name:         "Object #1",
          count:        4,
          active:       true,
          numbers:      [1,2,3,4,5],
          created_at:   "2019-02-24 00:00:00",
          updated_at:   "2019-02-24 00:00:00"
        }
      }

      let(:model_payload) {
        { object: model_data }.to_json
      }
      let(:list_payload) {
        model_1 = model_data.clone
        model_2 = model_data.clone
        model_2[:id] = "efghi12345"
        { objects: [ model_1, model_2 ] }.to_json
      }

      let(:bad_list_payload) {
        list_payload << "this is some bad data }{ ][,. "
      }

      let(:bad_list_type_payload) {
        list_payload = "500"
      }

      let(:bad_model_payload) {
        model_payload << "this is some bad data }{ ][,. "
      }

      let(:bad_model_type_payload) {
        model_payload = "500"
      }

      it "can transform a payload of model data into a model list", unit_test: true do
        list = endpoint.transform_list(list_payload)
        expect(list.class).to eq(WscSdk::ModelList)
        expect(list.success?).to be_truthy
        expect(list.length).to eq(2)
      end

      it "will handle a JSON error in a payload for a list of models", unit_test: true do
        bad_list = endpoint.transform_list(bad_list_payload)
        expect(bad_list.class).to eq(WscSdk::Models::Error)
        expect(bad_list.success?).to be_falsey
        expect(bad_list.status).to eq(422)
        expect(bad_list.code).to eq("ERR-422-PayloadInvalid")
      end

      it "will handle a type error in a payload for a list of models", unit_test: true do
        bad_list = endpoint.transform_list(bad_list_type_payload)
        expect(bad_list.class).to eq(WscSdk::Models::Error)
        expect(bad_list.success?).to be_falsey
        expect(bad_list.status).to eq(422)
        expect(bad_list.code).to eq("ERR-422-PayloadInvalid")
      end

      it "can transform a payload of individual model data into a model", unit_test: true do
        model = endpoint.transform_model(model_payload)
        expect(model.class).to eq(ObjectModel)
        expect(model.success?).to be_truthy
      end

      it "will handle a JSON error in a payload for an individual model", unit_test: true do
        bad_model = endpoint.transform_model(bad_model_payload)
        expect(bad_model.class).to eq(WscSdk::Models::Error)
        expect(bad_model.success?).to be_falsey
        expect(bad_model.status).to eq(422)
        expect(bad_model.code).to eq("ERR-422-PayloadInvalid")
      end

      it "will handle a type error in a payload for an individual model", unit_test: true do
        bad_list = endpoint.transform_model(bad_model_type_payload)
        expect(bad_list.class).to eq(WscSdk::Models::Error)
        expect(bad_list.success?).to be_falsey
        expect(bad_list.status).to eq(422)
        expect(bad_list.code).to eq("ERR-422-PayloadInvalid")
      end

      it "can handle a JSON error in a payload", unit_test: true do
        bad_model = endpoint.handle_json_error(JSON::ParserError.new(), "blah blah blah")
        expect(bad_model.class).to eq(WscSdk::Models::Error)
        expect(bad_model.success?).to be_falsey
        expect(bad_model.status).to eq(422)
        expect(bad_model.code).to eq("ERR-422-PayloadInvalid")
      end
    end

    context "Macros" do
      it "returns a base model class for generated objects", unit_test: true do
        expect(endpoint.class.model).to eq(ObjectModel)
      end

      it "defines model actions", unit_test: true do
        expect(endpoint.class.method_defined?(:foo)).to be_truthy
        expect(endpoint.class.method_defined?(:bar)).to be_truthy
        expect(endpoint.class.method_defined?(:baz)).to be_falsey
      end
    end

  end
end
