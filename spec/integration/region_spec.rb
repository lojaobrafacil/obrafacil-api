require "swagger_helper"

describe "Regions API" do
  path "/regions" do
    get "All a regions" do
      tags "Regions"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "region found" do
        auth_api
        let(:region) { create_list(:region, 5) }
        schema type: :array,
               items: {type: :object, properties: {
                 id: {type: :integer, example: 1},
                 name: {type: :string, example: "Norte"},
                 updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
                 created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
               }}
        run_test!
      end
    end
  end

  path "/regions/{id}" do
    get "Retrieves a region" do
      tags "Regions"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string

      response 200, "region found" do
        auth_api
        schema type: :object,
          properties: {
            id: {type: :integer, example: 1},
            name: {type: :string, example: "Norte"},
            updated_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
            created_at: {type: :string, example: "2018-03-15T16:54:07.552Z"},
          }

        let(:id) { create(:region).id }
        run_test!
      end

      response 404, "region not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
