require "swagger_helper"

describe "Cities API" do
  path "/cities" do
    get "All a cities" do
      tags "Cities"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false
      parameter name: :state_id, in: :query, type: :string, description: "cities of state ...", required: false

      response 200, "city found" do
        auth_api
        let(:cities) { create_list(:city, 5) }
        schema type: :array,
               items: {type: :object, properties: {
                 id: {type: :integer},
                 name: {type: :string, example: "Acrelândia"},
               }}
        run_test!
      end
    end
  end

  path "/cities/{id}" do
    get "Retrieves a city" do
      tags "Cities"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string

      response 200, "city found" do
        auth_api
        schema type: :object,
               properties: {
                 id: {type: :integer},
                 name: {type: :string, example: "Acrelândia"},
                 capital: {type: :boolean, example: false},
                 state: {type: :object, properties: {
                   id: {type: :integer},
                   name: {type: :string, example: "Acre"},
                   acronym: {type: :string, example: "AC"},
                   region_id: {type: :integer},
                   created_at: {type: :string, example: "2018-03-15T16:54:07.739Z"},
                   updated_at: {type: :string, example: "2018-03-15T16:54:07.739Z"},
                 }},
                 updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
                 created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
               }

        let(:id) { create(:city).id }
        run_test!
      end

      response 404, "city not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
