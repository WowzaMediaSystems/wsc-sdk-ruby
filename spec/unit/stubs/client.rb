base_path = "http://#{$simulator_hostname}/api/v1.1/"

load_stubs([
  {
    name: "Get Test",
    url: "#{base_path}",
    method: :get,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Get Pagination Test",
    url: "#{base_path}?page=1&per_page=50",
    method: :get,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Get Filters Test",
    url: "#{base_path}?filter%5B%5D%5Beq%5D=bar&filter%5B%5D%5Bfield%5D=foo",
    method: :get,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Get Params Test",
    url: "#{base_path}?foo=bar",
    method: :get,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Post Test",
    url: "#{base_path}",
    method: :post,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Put Test",
    url: "#{base_path}",
    method: :put,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Patch Test",
    url: "#{base_path}",
    method: :patch,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },

  {
    name: "Delete Test",
    url: "#{base_path}",
    method: :delete,
    response: {
      status: 200,
      body: {
        success: true
      }
    }
  },


  {
    name: "GET Players",
    url: "#{base_path}players",
    method: :get,
    response: {
      status: 200,
      body: {
        players: [
          {
            name: "Player 1"
          },
          {
            name: "Player 2"
          }
        ]
      }
    }
  },

  {
    name: "GET Player 1",
    url: "#{base_path}players/1",
    method: :get,
    response: {
      status: 200,
      body: {
        player: {
          name: "Player 1"
        }
      }
    }
  },

  {
    name: "POST Player 1",
    url: "#{base_path}players/1",
    method: :post,
    response: {
      status: 200,
      body: {
        player: {
          name: "Player 1"
        }
      }
    }
  },

  {
    name: "PUT Player 1",
    url: "#{base_path}players/1",
    method: :put,
    response: {
      status: 200,
      body: {
        player: {
          name: "Player 1 Updated"
        }
      }
    }
  },

  {
    name: "PATCH Player 1",
    url: "#{base_path}players/1",
    method: :patch,
    response: {
      status: 200,
      body: {
        player: {
          name: "Player 1 Updated"
        }
      }
    }
  },

  {
    name: "DELETE Player 1",
    url: "#{base_path}players/1",
    method: :delete,
    response: {
      status: 200,
      body: nil
    }
  },

  {
    name: "Bad JSON Response Player 2",
    url: "#{base_path}players/2",
    method: :get,
    response: {
      status: 500,
      raw_body: "{ \"player\": { \"name\": \"Player 2 Not Updated\""
    }
  }

])
