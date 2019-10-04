require "swagger_helper"

describe "Banks API" do
  path "/banks" do
    get "All a banks" do
      tags "Banks"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "bank found" do
        auth_api
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 code: { type: :integer },
                 name: { type: :string },
                 slug: { type: :string },
                 description: { type: :string },
               } }
        let(:bank) { create_list(:bank, 5) }
        run_test!
      end
    end
  end

  path "/banks" do
    post "Creates a bank" do
      tags "Banks"
      consumes "application/json"
      params_auth

      parameter name: :bank, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :integer, example: Faker::Number.number(digits: 4) },
          name: { type: :string, example: Faker::Bank.name },
          slug: { type: :string, example: Faker::Bank.name },
          description: { type: :string, example: Faker::Lorem.paragraph },
        },
        required: ["code", "name"],
      }

      response 201, "bank created" do
        auth_api
        let(:bank) { { code: 745, name: "Banco Citibank", slug: "Citibank", description: "www.citibank.com.br" } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:bank) { { code: 422 } }
        run_test!
      end
    end
  end

  path "/banks/{id}" do
    get "Retrieves a bank" do
      tags "Banks"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "bank found" do
        auth_api
        schema type: :object,
          properties: {
            id: { type: :integer },
            code: { type: :integer },
            name: { type: :string },
            slug: { type: :string },
            description: { type: :string },
          }

        let(:id) { create(:bank).id }
        run_test!
      end

      response 404, "bank not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/banks/{id}" do
    put "Updates a bank" do
      tags "Banks"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :bank, in: :body, schema: {
        type: :object,
        properties: {
          code: { type: :integer, example: Faker::Number.number(digits: 4) },
          name: { type: :string, example: Faker::Bank.name },
          slug: { type: :string, example: Faker::Bank.name },
          description: { type: :string, example: Faker::Lorem.paragraph },
        },
        required: ["code", "name"],
      }

      response 200, "bank updated" do
        auth_api
        let(:bank) { { code: 200, name: "test" } }
        let(:id) { create(:bank).id }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:bank) { { name: nil } }
        let(:id) { create(:bank).id }
        run_test!
      end
    end
  end

  path "/banks/{id}" do
    delete "Destroy a bank" do
      tags "Banks"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 204, "bank destroyed" do
        auth_api
        let(:id) { create(:bank).id }
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
