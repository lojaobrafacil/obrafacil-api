require "swagger_helper"

describe "Partners API" do
  path "/partners" do
    get "All a partners" do
      tags "Partners"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "partner found" do
        auth_api
        let(:partner) { create_list(:partner, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 federal_registration: { type: :string },
                 state_registration: { type: :string },
                 status: { type: :string },
                 description: { type: :string },
                 cash_redemption: { type: :string },
               } }
        run_test!
      end
    end
  end

  path "/partners/{id}" do
    get "Retrieves a partner" do
      tags "Partners"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "partner found" do
        auth_api
        let(:id) { create(:partner).id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            federal_registration: { type: :string },
            state_registration: { type: :string },
            kind: { type: :string },
            status: { type: :string },
            birthday: { type: :string },
            renewal_date: { type: :string },
            description: { type: :string },
            origin: { type: :string },
            percent: { type: :integer },
            agency: { type: :string },
            account: { type: :string },
            favored: { type: :string },
            favored_federal_registration: { type: :string },
            bank_id: { type: :integer },
            ocupation: { type: :string },
            partner_group: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
            user: { type: :object,
                   properties: {
              id: { type: :integer },
              email: { type: :string },
              federal_registration: { type: :string },
              kind: { type: :string, 'x-nullable': true },
              partner_id: { type: :integer, 'x-nullable': true },
              client_id: { type: :integer, 'x-nullable': true },
              created_at: { type: :string },
              updated_at: { type: :string },
            } },
            cash_redemption: { type: :string, 'x-nullable': true },
            updated_at: { type: :string },
            created_at: { type: :string },
            addresses: { type: :array,
                        items: { type: :object, properties: {
              id: { type: :integer },
              street: { type: :string },
              number: { type: :string },
              complement: { type: :string },
              neighborhood: { type: :string },
              zipcode: { type: :string },
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
              contact: { type: :string, 'x-nullable': true },
              phone_type_id: { type: :integer },
              phone_type_name: { type: :string },
              updated_at: { type: :string },
              created_at: { type: :string },
            } } },
            emails: { type: :array,
                     items: { type: :object, properties: {
              id: { type: :integer },
              email: { type: :string },
              contact: { type: :string, 'x-nullable': true },
              email_type_id: { type: :integer },
              email_type_name: { type: :string },
              updated_at: { type: :string },
              created_at: { type: :string },
            } } },
            coupon: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
              code: { type: :string },
              discount: { type: :float },
              status: { type: :string },
              kind: { type: :string },
              max_value: { type: :float },
              expired_at: { type: :string },
              starts_at: { type: :string },
              total_uses: { type: :integer },
              client_uses: { type: :integer },
              shipping: { type: :boolean },
              logged: { type: :boolean },
              description: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string },
            } },
          }
        run_test!
      end

      response 404, "partner not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/partners" do
    post "Creates a partner" do
      tags "Partners"
      consumes "application/json"
      params_auth

      parameter name: :partner, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          kind: { type: :string, example: "physical or legal" },
          status: { type: :string, example: "pre_active, active or inactive" },
          birthday: { type: :string, example: Faker::Date.birthday(min_age: 18, max_age: 65) },
          renewal_date: { type: :string, example: Faker::Date.forward(days: 1000) },
          description: { type: :string, example: Faker::Lorem.paragraph },
          origin: { type: :string, example: "shop, internet, relationship or nivaldo" },
          percent: { type: :string, example: Faker::Number.decimal(l_digits: 0, r_digits: 2) },
          agency: { type: :string, example: Faker::Number.number(digits: 4) },
          account: { type: :string, example: Faker::Number.number(digits: 7) },
          favored: { type: :string, example: Faker::Name.name },
          favored_federal_registration: { type: :string, example: Faker::Code.isbn },
          bank_id: { type: :integer },
          ocupation: { type: :string, example: Faker::Job.field },
          cash_redemption: { type: :string, example: "true, false or maybe" },
          partner_group_id: { type: :integer },
        },
        required: ["name", "federal_registration", "kind"],
      }

      response 201, "partner created" do
        auth_api
        let(:partner) { attributes_for(:partner) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:partner) { { name: "foo" } }
        run_test!
      end
    end
  end

  path "/partners/{id}" do
    put "Updates a partner" do
      tags "Partners"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :partner, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          federal_registration: { type: :string, example: Faker::Code.isbn },
          state_registration: { type: :string, example: Faker::Code.isbn },
          kind: { type: :string, example: "physical or legal" },
          status: { type: :string, example: "pre_active, active or inactive" },
          birthday: { type: :string, example: Faker::Date.birthday(min_age: 18, max_age: 65) },
          renewal_date: { type: :string, example: Faker::Date.forward(days: 1000) },
          description: { type: :string, example: Faker::Lorem.paragraph },
          origin: { type: :string, example: "shop, internet, relationship or nivaldo" },
          percent: { type: :string, example: Faker::Number.decimal(l_digits: 0, r_digits: 2) },
          agency: { type: :string, example: Faker::Number.number(digits: 4) },
          account: { type: :string, example: Faker::Number.number(digits: 7) },
          favored: { type: :string, example: Faker::Name.name },
          favored_federal_registration: { type: :string, example: Faker::Code.isbn },
          bank_id: { type: :integer },
          ocupation: { type: :string, example: Faker::Job.field },
          cash_redemption: { type: :string, example: "true, false or maybe" },
          partner_group_id: { type: :integer },
        },
        required: ["name", "federal_registration", "kind"],
      }

      response 200, "partner updated" do
        auth_api
        let(:partner) { { name: "newname" } }
        let(:id) { create(:partner).id }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:partner) { { name: nil } }
        let(:id) { create(:partner).id }
        run_test!
      end
    end
  end

  path "/partners/{id}" do
    delete "Destroy a partner" do
      tags "Partners"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "partner destroyed" do
        auth_api
        let(:id) { create(:partner, deleted_by_id: create(:employee).id).id }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end
end
