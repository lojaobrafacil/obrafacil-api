require "swagger_helper"

describe "Coupons API" do
  path "/coupons" do
    get "All a coupons" do
      tags "Coupons"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "coupon found" do
        auth_api
        let(:coupon) { create_list(:coupon, 5) }
        schema type: :array,
               items: { type: :object, properties: {
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
                 partner: { type: :object, properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   status: { type: :string },
                 } },
                 description: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
               } }
        run_test!
      end
    end
  end

  path "/coupons/{id}" do
    get "Retrieves a coupon" do
      tags "Coupons"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "coupon found" do
        auth_api
        schema type: :object,
          properties: {
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
            partner: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
              status: { type: :string },
            } },
            description: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
          }

        let(:id) { create(:partner).coupon.id }
        run_test!
      end

      response 404, "coupon not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/coupons" do
    post "Creates a coupon" do
      tags "Coupons"
      consumes "application/json"
      params_auth

      parameter name: :coupon, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          discount: { type: :float, example: Faker::Number.decimal(1, 0) },
          status: { type: :string, example: "active or inactive" },
          kind: { type: :string, example: "percent or value" },
          max_value: { type: :float, example: Faker::Number.decimal(3, 0) },
          expired_at: { type: :string, example: DateTime.now + 1.year },
          starts_at: { type: :string, example: DateTime.now },
          total_uses: { type: :integer, example: Faker::Number.number(2) },
          client_uses: { type: :integer, example: Faker::Number.number(2) },
          shipping: { type: :boolean, example: "true or false" },
          logged: { type: :boolean, example: "true or false" },
          description: { type: :string, example: Faker::Lorem.paragraph },
        },
        required: ["name", "discount", "starts_at", "expired_at"],
      }

      response 201, "coupon created" do
        auth_api
        let(:coupon) { attributes_for(:coupon) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:coupon) { { name: "foo" } }
        run_test!
      end
    end
  end

  path "/coupons/{id}" do
    put "Updates a coupon" do
      tags "Coupons"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :coupon, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: Faker::Name.name },
          discount: { type: :string, example: Faker::Number.decimal(1, 0) },
          status: { type: :string, example: "active or inactive" },
          kind: { type: :string, example: "percent or value" },
          max_value: { type: :string, example: Faker::Number.decimal(3, 0) },
          expired_at: { type: :string, example: DateTime.now + 1.year },
          starts_at: { type: :string, example: DateTime.now },
          total_uses: { type: :string, example: Faker::Number.number(2) },
          client_uses: { type: :string, example: Faker::Number.number(2) },
          shipping: { type: :string, example: "true or false" },
          logged: { type: :string, example: "true or false" },
          description: { type: :string, example: Faker::Lorem.paragraph },
        },
        required: ["name", "discount", "starts_at", "expired_at"],
      }

      response 200, "coupon updated" do
        auth_api
        let(:coupon) { { name: "newname" } }
        let(:id) { create(:coupon).id }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:coupon) { { name: nil } }
        let(:id) { create(:coupon).id }
        run_test!
      end
    end
  end

  path "/coupons/by_code/{code}" do
    get "Retrieves a coupon by code" do
      tags "Coupons"
      consumes "application/json"
      params_auth
      parameter name: :code, :in => :path, :type => :string, required: true, description: "Coupon code"
      parameter name: :client_federal_registration, :in => :query, :type => :string, required: false, description: "To validate usage per client"

      response 200, "Success" do
        auth_api
        let(:code) { create(:partner).coupon.code }
        let(:client_federal_registration) { Faker::Number.number(11) }
        schema type: :object, properties: {
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
                 partner: { type: :object, properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   status: { type: :string },
                 } },
                 description: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
               }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:code) { "invalid" }
        schema type: :object, properties: {
                 errors: { type: :string, example: I18n.t("models.coupon.errors.not_found") },
               }
        run_test!
      end
    end
  end

  path "/coupons/use/{code}" do
    post "Use a coupon by code" do
      tags "Coupons"
      consumes "application/json"
      params_auth
      parameter name: :code, :in => :path, :type => :string, required: true

      parameter name: :coupon, in: :body, schema: {
        type: :object,
        properties: {
          external_order_id: { type: :string, example: Faker::Number.number(4) },
          client_federal_registration: { type: :string, example: Faker::Number.number(11) },
        },
        required: ["external_order_id", "client_federal_registration"],
      }

      response 200, "coupon used" do
        auth_api
        let(:code) { create(:coupon).code }
        let(:coupon) { attributes_for(:log_coupon) }
        schema type: :object, properties: {
                 success: { type: :string, example: I18n.t("models.coupon.response.used") },
               }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:code) { "invalid" }
        let(:coupon) { attributes_for(:log_coupon) }
        schema type: :object, properties: {
                 errors: { type: :string, example: I18n.t("models.coupon.errors.not_found") },
               }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:code) { create(:coupon).code }
        let(:coupon) { { external_order_id: nil } }
        schema type: :object, properties: {
          errors: { type: :string, example: I18n.t("models.coupon.errors.already_used") },
        }
        run_test!
      end
    end
  end
end
