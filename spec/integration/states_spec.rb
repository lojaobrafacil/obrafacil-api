require "swagger_helper"

describe "States API" do
  path "/states" do
    get "All a states" do
      tags "States"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "state found" do
        auth_api
        let(:state) { create_list(:state, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: "Acre" },
                 acronym: { type: :string, example: "AC" },
               } }
        run_test!
      end
    end
  end

  path "/states/{id}" do
    get "Retrieves a state" do
      tags "States"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string

      response 200, "state found" do
        auth_api
        schema type: :object,
          properties: {
            id: { type: :integer, example: 1 },
            name: { type: :string, example: "Acre" },
            acronym: { type: :string, example: "AC" },
            region: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string, example: "Norte" },
              created_at: { type: :string, example: "2018-03-15T16:54:07.739Z" },
              updated_at: { type: :string, example: "2018-03-15T16:54:07.739Z" },
            } },
            updated_at: { type: :string, example: "2018-03-15T16:54:07.552Z" },
            created_at: { type: :string, example: "2018-03-15T16:54:07.552Z" },
          }

        let(:id) { create(:state).id }
        run_test!
      end

      response 404, "state not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
