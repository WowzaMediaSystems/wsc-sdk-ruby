base_path = "http://#{$simulator_hostname}/api/#{WscSdk::PATH_VERSION}"

stub_objects = [
  {
    id:           "abcd1234",
    name:         "Object #1",
    count:        4,
    active:       true,
    numbers:      [1,2,3,4,5],
    created_at:   "2019-02-24 00:00:00",
    updated_at:   "2019-02-24 00:00:00"

  },
  {
    id:           "efgh5678",
    name:         "Object #2",
    count:        8,
    active:       false,
    numbers:      [6,7,8,9],
    created_at:   "2019-02-23 00:00:00",
    updated_at:   "2019-02-23 00:00:00"
  },
  {
    id:           "wxyz9876",
    name:         "Object #3",
    count:        99,
    active:       true,
    numbers:      [1,2],
    created_at:   "2019-02-26 00:00:00",
    updated_at:   "2019-02-26 00:00:00"
  },
  {
    id:           "abcd1234",
    name:         "Updated Object #1",
    count:        5,
    active:       false,
    numbers:      [3,4,5],
    created_at:   "2019-02-24 00:00:00",
    updated_at:   "2019-02-27 00:00:00"

  },
  {
    id:           "efgh5678",
    name:         "Updated Object #2",
    count:        3,
    active:       false,
    numbers:      [8,9],
    created_at:   "2019-02-23 00:00:00",
    updated_at:   "2019-02-27 00:00:00"
  }
]

# Name objects from the list so that they are easily referenced and modified
# in the stubs.
#
# NOTE: Regarding `stub_objects[0..0]` vs. `stub_objects[0]`.  The former
# returns an array of 1 object, the latter returns just the object.  This is
# intended for the two uses where either a list (former) is needed or an
# individual object (latter).
#
# This is for future you and me, because we all know how we question each others
# practices.  Rightfully so.  Sometimes we've had too much coffee and not enough
# sleep.  Nothing is more fun than being wide awake and brain-dead while writing
# code.
#
list_objects          = stub_objects[0..1]
list_page_1_objects   = stub_objects[0..0]
list_page_2_objects   = stub_objects[1..1]
list_filtered_objects = stub_objects[0..0]
list_param_objects    = stub_objects[0..0]

find_object_1         = stub_objects[0]
find_object_2         = stub_objects[1]
new_object            = stub_objects[2]
updated_object_1      = stub_objects[3]
updated_object_2      = stub_objects[4]

load_stubs([
  {
    name: "List Objects",
    url: "#{base_path}/objects",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: list_objects
      }
    }
  },

  {
    name: "List Objects: Page 1",
    url: "#{base_path}/objects?page=1&per_page=1",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: list_page_1_objects
      }
    }
  },

  {
    name: "List Objects: Page 2",
    url: "#{base_path}/objects?page=2&per_page=1",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: list_page_2_objects
      }
    }
  },

  {
    name: "List Objects: Filter 'foo'",
    url: "#{base_path}/objects?filter%5B%5D%5Beq%5D=bar&filter%5B%5D%5Bfield%5D=foo",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: list_filtered_objects
      }
    }
  },


  {
    name: "List Objects: Param 'foo'",
    url: "#{base_path}/objects?foo=bar",
    method: :get,
    response: {
      status: 200,
      body: {
        objects: list_param_objects
      }
    }
  },

  {
    name: "Find Object 1",
    url: "#{base_path}/objects/abcd1234",
    method: :get,
    response: {
      status: 200,
      body: {
        object: find_object_1
      }
    }
  },

  {
    name: "Find Object 2",
    url: "#{base_path}/objects/efgh5678",
    method: :get,
    response: {
      status: 200,
      body: {
        object: find_object_2
      }
    }
  },

  {
    name: "Create New Object 1",
    url: "#{base_path}/objects",
    method: :post,
    response: {
      status: 200,
      body: {
        object: new_object
      }
    }
  },

  {
    name: "Updated Object 1",
    url: "#{base_path}/objects/abcd1234",
    method: :put,
    response: {
      status: 200,
      body: {
        object: updated_object_1
      }
    }
  },

  {
    name: "Updated Object 2",
    url: "#{base_path}/objects/efgh5678",
    method: :put,
    response: {
      status: 200,
      body: {
        object: updated_object_2
      }
    }
  },


  {
    name: "Delete Object 1",
    url: "#{base_path}/objects/abcd1234",
    method: :delete,
    response: {
      status: 204,
      body: nil
    }
  },

])
