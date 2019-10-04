require "swagger_helper"

describe "Suppliers API" do
  path "/suppliers" do
    get "All a suppliers" do
      tags "Suppliers"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :'per-page', in: :query, type: :string, description: "itens per page", required: false

      response 200, "supplier found" do
        auth_api
        let(:suppliers) { FactoryBot.create_list(:supplier, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 fantaty_name: { type: :string },
                 description: { type: :string },
               } }
        run_test!
      end
    end
  end

  path "/suppliers/{id}" do
    get "Retrieves a supplier" do
      tags "Suppliers"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "supplier found" do
        auth_api
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            fantasy_name: { type: :string },
            federal_registration: { type: :string },
            state_registration: { type: :string },
            kind: { type: :string, 'x-nullable': true },
            birth_date: { type: :string },
            tax_regime: { type: :string },
            description: { type: :string },
            billing_type_id: { type: :integer },
            updated_at: { type: :string },
            created_at: { type: :string },
            addresses: { type: :array,
                        items: { type: :object, properties: {
              id: { type: :integer },
              street: { type: :string },
              number: { type: :string },
              complement: { type: :string },
              neighborhood: { type: :string },
              zipcode: { type: :integer },
              ibge: { type: :string },
              description: { type: :string },
              address_type_id: { type: :integer },
              address_type_name: { type: :string },
              city_id: { type: :integer },
              city_name: { type: :string },
              state_id: { type: :integer },
              state_name: { type: :string },
            } } },
            phones: { type: :array,
                     items: { type: :object, properties: {
              id: { type: :integer },
              phone: { type: :string },
              contact: { type: :string },
              phone_type_id: { type: :integer },
              phone_type_name: { type: :string },
              updated_at: { type: :string },
              created_at: { type: :string },
            } } },
            emails: { type: :array,
                     items: { type: :object, properties: {
              id: { type: :integer },
              email: { type: :string },
              contact: { type: :string },
              email_type_id: { type: :integer },
              email_type_name: { type: :string },
              updated_at: { type: :string },
              created_at: { type: :string },
            } } },
          }

        let(:id) { create(:supplier).id }
        run_test!
      end

      response 404, "supplier not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/suppliers" do
    post "Creates a supplier" do
      tags "Suppliers"
      consumes "application/json"
      params_auth

      parameter name: :supplier, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          fantasy_name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          kind: { type: :string, example: "physical", description: "physical or legal" },
          birth_date: { type: :string, example: Faker::Date.birthday(min_age: 18, max_age: 65) },
          tax_regime: { type: :string, example: Faker::Date.forward(days: 1000) },
          description: { type: :string, example: "simple", description: "pode ser simple, normal ou presumed" },
          billing_type_id: { type: :integer },
          addresses: { type: :object,
                      properties: {
            street: { type: :string, example: Faker::Address.street_name },
            number: { type: :string, example: Faker::Address.street_name },
            complement: { type: :string, example: Faker::Number.number(digits: 8) },
            neighborhood: { type: :string, example: Faker::Number.number(digits: 8) },
            zipcode: { type: :integer, example: Faker::Number.number(digits: 4) },
            ibge: { type: :string, example: Faker::Address.building_number },
            description: { type: :string, example: Faker::Lorem.paragraph },
            address_type_id: { type: :integer, description: "outros é 4" },
            city_id: { type: :integer, description: "são paulo é 5351" },
          },
                      required: ["street", "zipcode"] },
          phones: { type: :object,
                   properties: {
            phone: { type: :string, example: Faker::PhoneNumber.phone_number },
            contact: { type: :string, example: Faker::Name.name },
            phone_type_id: { type: :integer, description: "outros é 4" },
          },
                   required: ["phone", "phone_type_id"] },
          emails: { type: :object,
                   properties: {
            email: { type: :string, example: Faker::Internet.email },
            contact: { type: :string, example: Faker::Name.name },
            email_type_id: { type: :integer, description: "outros é 4" },
          },
                   required: ["email", "email_type_id"] },
        },
        required: ["name", "federal_registration", "kind", "tax_regime"],
      }

      response 201, "supplier created" do
        auth_api
        let(:supplier) { attributes_for(:supplier) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:supplier) { { name: nil } }
        run_test!
      end
    end
  end

  path "/suppliers/{id}" do
    put "Updates a supplier" do
      tags "Suppliers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :supplier, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          fantasy_name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          kind: { type: :string, example: "physical", description: "physical or legal" },
          birth_date: { type: :string, example: Faker::Date.birthday(min_age: 18, max_age: 65) },
          tax_regime: { type: :string, example: Faker::Date.forward(days: 1000) },
          description: { type: :string, example: "simple", description: "pode ser simple, normal ou presumed" },
          billing_type_id: { type: :integer },
          addresses: { type: :object,
                      properties: {
            street: { type: :string, example: Faker::Address.street_name },
            number: { type: :string, example: Faker::Address.street_name },
            complement: { type: :string, example: Faker::Number.number(digits: 8) },
            neighborhood: { type: :string, example: Faker::Number.number(digits: 8) },
            zipcode: { type: :integer, example: Faker::Number.number(digits: 4) },
            ibge: { type: :string, example: Faker::Address.building_number },
            description: { type: :string, example: Faker::Lorem.paragraph },
            address_type_id: { type: :integer, description: "outros é 4" },
            city_id: { type: :integer, description: "são paulo é 5351" },
          },
                      required: ["street", "zipcode"] },
          phones: { type: :object,
                   properties: {
            phone: { type: :string, example: Faker::PhoneNumber.phone_number },
            contact: { type: :string, example: Faker::Name.name },
            phone_type_id: { type: :integer, description: "outros é 4" },
          },
                   required: ["phone", "phone_type_id"] },
          emails: { type: :object,
                   properties: {
            email: { type: :string, example: Faker::Internet.email },
            contact: { type: :string, example: Faker::Name.name },
            email_type_id: { type: :integer, description: "outros é 4" },
          },
                   required: ["email", "email_type_id"] },
        },
        required: ["name", "federal_registration", "kind", "tax_regime"],
      }

      response 200, "supplier updated" do
        auth_api
        let(:supplier) { { name: "newname" } }
        let(:id) { create(:supplier).id }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        let(:supplier) { { name: nil } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:supplier) { { name: nil } }
        let(:id) { create(:supplier).id }
        run_test!
      end
    end
  end

  path "/suppliers/{id}" do
    delete "Destroy a supplier" do
      tags "Suppliers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 204, "supplier destroyed" do
        auth_api
        let(:id) { create(:supplier).id }
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
