require "swagger_helper"

describe "Units API" do
  path "/units" do
    get "All a units" do
      tags "Units"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "unit found" do
        auth_api
        let(:unit) { create_list(:unit, 5) }
        schema type: :array,
               items: {type: :object, properties: {
                 id: {type: :integer, example: 1},
                 name: {type: :string, example: "m2"},
                 description: {type: :string, example: "Metro quadrado"},
               }}
        run_test!
      end
    end
  end

  path "/units/{id}" do
    get "Retrieves a unit" do
      tags "Units"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "unit found" do
        auth_api
        schema type: :object,
          properties: {
            id: {type: :integer, example: 1},
            name: {type: :string, example: "m2"},
            description: {type: :string, example: "Metro quadrado"},
            updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
            created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
          }
        let(:id) { create(:unit).id }
        run_test!
      end

      response 404, "unit not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/units" do
    post "Creates a unit" do
      tags "Units"
      consumes "application/json"
      params_auth

      parameter name: :unit, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "m2"},
          description: {type: :string, example: "Metro quadrado"},
          updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
          created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
        },
        required: ["name", "description"],
      }

      response 201, "unit created" do
        auth_api
        let(:unit) { create(:unit) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:unit) { {name: nil} }
        run_test!
      end
    end
  end

  path "/units/{id}" do
    put "Updates a unit" do
      tags "Units"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string

      parameter name: :unit, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, example: "m2"},
          description: {type: :string, example: "Metro quadrado"},
          updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
          created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
        },
        required: ["name", "description"],
      }

      response 200, "unit updated" do
        auth_api
        let(:id) { create(:unit).id }
        let(:unit) { {name: "String"} }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:id) { create(:unit).id }
        let(:unit) { {name: nil} }
        run_test!
      end
    end
  end

  path "/units/{id}" do
    delete "Destroy a unit" do
      tags "Units"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string

      response 204, "unit destroyed" do
        auth_api
        let(:id) { create(:unit).id }
        run_test!
      end

      response 404, "invalid request" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
