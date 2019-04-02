require "unit/spec_helper"
require "unit/webmock_helper"

require "unit/helpers/object_endpoints"
require "unit/helpers/primary_object_model"
require "unit/stubs/object_model"

describe WscSdk::Model do

  let(:client)          { WscSdk::Client.new }
  let(:endpoint)        { ObjectEndpoints.new(client) }

  it "can initialize properly", unit_test: true do
    model = ObjectModel.new(endpoint, name: "Test Model" )
  end

  context "Model Behaviors" do
    let(:model)         { ObjectModel.new(endpoint, name: "Test Model" )}
    let(:new_model)     { ObjectModel.new(endpoint, name: "Test New Model" )}
    let(:primary_model) { PrimaryObjectModel.new(endpoint, id: "abcd1234", uid: "efgh5678", name: "Test Primary Key Model" )}

    it "returns a primary key value", unit_test: true do
      model.ingest_attributes({ id: "abcd1234" }, write_to_read_only: true)
      expect(model.primary_key).to eq("abcd1234")

      primary_model.ingest_attributes({ uid: "efgh5678" }, write_to_read_only: true)
      expect(primary_model.primary_key).to eq("efgh5678")
    end

    it "returns a primary key attribute name", unit_test: true do
      expect(model.primary_key_attribute).to eq(:id)
      expect(primary_model.primary_key_attribute).to eq(:uid)
    end

    it "can clear its primary key value", unit_test: true do
      object_1 = endpoint.find('abcd1234')
      expect(object_1.primary_key).to eq('abcd1234')
      object_1.clear_primary_key
      expect(object_1.primary_key).to be_nil
    end

    context("Manage Attributes") do
      let(:attr_model) {  ObjectModel.new(endpoint, name: "Test New Model") }

      it "can return the current schema", unit_test: true do
        schema = attr_model.schema
        expect(schema.class).to eq(WscSdk::Schema)

        attribute = schema[:name]
        expect(attribute.class).to eq(WscSdk::SchemaAttribute)
        expect(attribute.name).to eq(:name)
        expect(attribute.type).to eq(:string)
        expect(attribute.access).to eq(:read_write)
      end

      it "can initialize its attributes", unit_test: true do
        attributes = attr_model.initialize_attributes
        expect(attributes[:default_int]).to eq(0)
        expect(attributes[:default_str]).to eq("test")
        expect(attributes[:active]).to be_nil
        expect(attributes[:count]).to be_nil
      end

      it "can ingest attributes", unit_test: true do
        expect(attr_model.default_int).to eq(0)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("test")
        expect(attr_model.active).to be_nil
        expect(attr_model.count).to be_nil

        attr_model.ingest_attributes(
          default_int: 2,
          ingest_test: "ingested",
          default_str: "tested",
          active: true,
          count: 1
        )

        expect(attr_model.default_int).to eq(2)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("tested")
        expect(attr_model.active).to be_truthy
        expect(attr_model.count).to eq(1)
        expect(attr_model.dirty?).to be_truthy
      end

      it "can ingest attributes and write to read only attributes", unit_test: true do
        expect(attr_model.default_int).to eq(0)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("test")
        expect(attr_model.active).to be_nil
        expect(attr_model.count).to be_nil

        attr_model.ingest_attributes(
          {
            default_int: 2,
            ingest_test: "ingested",
            default_str: "tested",
            active: true,
            count: 1
          },
          write_to_read_only: true
        )

        expect(attr_model.default_int).to eq(2)
        expect(attr_model.ingest_test).to eq("ingested")
        expect(attr_model.default_str).to eq("tested")
        expect(attr_model.active).to be_truthy
        expect(attr_model.count).to eq(1)
        expect(attr_model.dirty?).to be_truthy
      end

      it "can ingest attributes and mark itself clean when finished", unit_test: true do
        expect(attr_model.default_int).to eq(0)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("test")
        expect(attr_model.active).to be_nil
        expect(attr_model.count).to be_nil

        attr_model.ingest_attributes(
          {
            default_int: 2,
            ingest_test: "ingested",
            default_str: "tested",
            active: true,
            count: 1
          },
          mark_clean: true
        )

        expect(attr_model.default_int).to eq(2)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("tested")
        expect(attr_model.active).to be_truthy
        expect(attr_model.count).to eq(1)
        expect(attr_model.dirty?).to be_falsey
      end


      it "can ingest a single attribute", unit_test: true do
        expect(attr_model.default_int).to eq(0)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("test")
        expect(attr_model.active).to be_nil
        expect(attr_model.count).to be_nil

        attr_model.ingest_attribute(:default_int, 1)
        attr_model.ingest_attribute(:ingest_test, "ingested")

        expect(attr_model.default_int).to eq(1)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.dirty?).to be_truthy
      end

      it "can ingest a single attribute and write to a read only attribute", unit_test: true do
        expect(attr_model.default_int).to eq(0)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("test")
        expect(attr_model.active).to be_nil
        expect(attr_model.count).to be_nil

        attr_model.ingest_attribute(:default_int, 1, write_to_read_only: true)
        attr_model.ingest_attribute(:ingest_test, "ingested", write_to_read_only: true)

        expect(attr_model.default_int).to eq(1)
        expect(attr_model.ingest_test).to eq("ingested")
        expect(attr_model.dirty?).to be_truthy
      end

      it "determine if it has a specific attributes", unit_test: true do
        expect(attr_model.has_attribute?(:default_int)).to be_truthy
        expect(attr_model.has_attribute?(:not_an_attribute)).to be_falsey
      end

      it "can determine if the attributes are currently dirty and mark them as clean", unit_test: true do
        expect(attr_model.dirty?).to be_falsey
        attr_model.ingest_attribute(:default_int, 1, write_to_read_only: true)
        expect(attr_model.dirty?).to be_truthy
        expect(attr_model.changes).to include(:default_int)
        attr_model.clean!
        expect(attr_model.dirty?).to be_falsey
      end

      it "can bulk assign attributes", unit_test: true do
        expect(attr_model.dirty?).to be_falsey
        attr_model.attributes = {
          default_int: 1,
          ingest_test: "ingested",
          default_str: "tested"
        }
        expect(attr_model.dirty?).to be_truthy
        expect(attr_model.default_int).to eq(1)
        expect(attr_model.ingest_test).to eq("not ingested")
        expect(attr_model.default_str).to eq("tested")
        expect(attr_model.active).to be_nil
      end

      it "can validate the attributes and raise an exception if it's invalid", unit_test: true do
        expect{ attr_model.validate! }.to raise_error(Exception)
      end

      it "can validate its attributes", unit_test: true do
        attr_model.validate_str = nil
        expect(attr_model.valid?).to be_falsey
        attr_model.validate_str = "valid"
        expect(attr_model.valid?).to be_truthy
      end

    end

    context "Manage State" do
      it "can determine if it's a new model", unit_test: true do
        expect(new_model.new_model?).to be_truthy

        model.ingest_attributes({ id: "abcd1234" }, write_to_read_only: true)
        expect(model.new_model?).to be_falsey
      end

      it "can return a success status", unit_test: true do
        expect(model.success?).to be_truthy
      end

      it "can build a payload according to its schema", unit_test: true do
        payload = model.build_payload
        expect(payload.has_key?(model.class.singular_name)).to be_truthy
        expect(payload[:object][:name]).to eq("Test Model")
      end

      it "can save its attribute data when it's new", unit_test: true do
        new_object = endpoint.build()
        expect(new_object.class).to eq(ObjectModel)
        expect(new_object.new_model?).to be_truthy

        new_object.name     = "Object #3"
        new_object.count    = 99
        new_object.active   = true
        new_object.numbers  = [1,2]

        expect(new_object.save.success?).to be_truthy
        expect(new_object.new_model?).to be_falsey
        expect(new_object.id).to eq("wxyz9876")
        expect(new_object.name).to eq("Object #3")
        expect(new_object.count).to eq(99)
        expect(new_object.active).to eq(true)
        expect(new_object.numbers).to eq([1,2])
        expect(new_object.created_at).to eq("2019-02-26 00:00:00")
        expect(new_object.updated_at).to eq("2019-02-26 00:00:00")
      end

      it "can save its attribute data when it exists already", unit_test: true do
        object_1 = endpoint.find('abcd1234')
        expect(object_1.new_model?).to be_falsey

        object_1.name     = "Updated Object #1"
        object_1.count    = 5
        object_1.active   = false
        object_1.numbers  = [3,4,5]

        expect(object_1.save.success?).to be_truthy
        expect(object_1.new_model?).to be_falsey
        expect(object_1.name).to eq("Updated Object #1")
        expect(object_1.count).to eq(5)
        expect(object_1.active).to eq(false)
        expect(object_1.numbers).to eq([3,4,5])
        expect(object_1.created_at).to eq("2019-02-24 00:00:00")
        expect(object_1.updated_at).to eq("2019-02-27 00:00:00")
      end

      it "can refresh itself", unit_test: true do
        object_1 = endpoint.find("abcd1234")
        object_1.name = "This is bad data"

        expect(object_1.refresh.success?).to be_truthy
        expect(object_1.name).to eq("Object #1")
      end

      it "can delete itself", unit_test: true do
        object_1 = endpoint.find("abcd1234")

        expect(object_1.delete.success?).to be_truthy
        expect(object_1.new_model?).to be_truthy
        expect(object_1.name).to eq("Object #1")
        expect(object_1.count).to eq(4)
        expect(object_1.active).to eq(true)
        expect(object_1.numbers).to eq([1,2,3,4,5])
        expect(object_1.created_at).to eq("2019-02-24 00:00:00")
        expect(object_1.updated_at).to eq("2019-02-24 00:00:00")
      end
    end

    context "Macros" do

      it "generates a model name singular method", unit_test: true do
        expect(model.class.singular_name).to eq(:object)
      end

      it "generates a model name plural method", unit_test: true do
        expect(model.class.plural_name).to eq(:objects)
      end

      it "builds getters for read and read/write attributes", unit_test: true do
        expect{ test = model.id }.not_to raise_error(Exception)
        model_id = "read only"
        expect( model.id ).not_to eq("read only")
        expect{ test = model.name }.not_to raise_error(Exception)
      end

      it "builds setters for write and read/write attributes", unit_test: true do
        puts "Model: #{model.name}"
        expect{ test = model.write_only }.to raise_error(Exception)
        expect{ model.write_only = "write only" }.not_to raise_error(Exception)
        expect{ model.name = "read/write" }.not_to raise_error(Exception)
      end
    end
  end
end
