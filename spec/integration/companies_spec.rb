require "swagger_helper"

describe "Company API" do
  path "/companies" do
    get "All a companies" do
      tags "Companies"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :'per-page', in: :query, type: :string, description: "itens per page", required: false

      response 200, "company found" do
        auth_api
        let(:companies) { FactoryBot.create_list(:company, 5) }
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

  path "/companies/{id}" do
    get "Retrieves a company" do
      tags "Companies"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "company found" do
        auth_api
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            fantasy_name: { type: :string },
            federal_registration: { type: :string },
            state_registration: { type: :string },
            invoice_save: { type: :string },
            invouce_return: { type: :string },
            pis_percent: { type: :integer },
            confins_percent: { type: :integer },
            icmsn_percent: { type: :integer },
            birth_date: { type: :string },
            tax_regime: { type: :string },
            description: { type: :string },
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

        let(:id) { create(:company).id }
        run_test!
      end

      response 404, "company not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/companies" do
    post "Creates a company" do
      tags "Companies"
      consumes "application/json"
      params_auth

      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          fantasy_name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          invoice_save: { type: :string, example: Faker::Code.isbn },
          invouce_return: { type: :string, example: Faker::Code.isbn },
          pis_percent: { type: :string, example: Faker::Code.isbn },
          confins_percent: { type: :string, example: Faker::Code.isbn },
          icmsn_percent: { type: :string, example: Faker::Code.isbn },
          birth_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          tax_regime: { type: :string, example: Faker::Date.forward(10000) },
          description: { type: :string, example: "simple", description: "pode ser simple, normal ou presumed" },
        },
        required: ["name", "federal_registration", "kind", "tax_regime"],
      }

      response 201, "company created" do
        auth_api
        let(:company) { attributes_for(:company) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:company) { { name: nil } }
        run_test!
      end
    end
  end

  path "/companies/{id}" do
    put "Updates a company" do
      tags "Companies"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          fantasy_name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          invoice_save: { type: :string, example: Faker::Code.isbn },
          invouce_return: { type: :string, example: Faker::Code.isbn },
          pis_percent: { type: :string, example: Faker::Code.isbn },
          confins_percent: { type: :string, example: Faker::Code.isbn },
          icmsn_percent: { type: :string, example: Faker::Code.isbn },
          birth_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          tax_regime: { type: :string, example: Faker::Date.forward(10000) },
          description: { type: :string, example: "simple", description: "pode ser simple, normal ou presumed" },
        },
        required: ["name", "federal_registration", "kind", "tax_regime"],
      }

      response 200, "company updated" do
        auth_api
        let(:company) { { name: "newname" } }
        let(:id) { create(:company).id }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        let(:company) { { name: nil } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:company) { { name: nil } }
        let(:id) { create(:company).id }
        run_test!
      end
    end
  end

  path "/companies/{id}" do
    delete "Destroy a company" do
      tags "Companies"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 204, "company destroyed" do
        auth_api
        let(:id) { create(:company).id }
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
