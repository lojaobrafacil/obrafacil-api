require "swagger_helper"

describe "Commission API" do
  path "/commissions" do
    get "All a commissions" do
      tags "Commissions"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :'per-page', in: :query, type: :string, description: "itens per page", required: false
      parameter name: :'partner_id', in: :query, type: :string, description: "itens per page", required: true

      response 200, "commission found" do
        auth_api
        let(:commissions) { FactoryBot.create_list(:commission, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 order_id: { type: :integer },
                 order_date: { type: :string },
                 client_name: { type: :string },
                 order_price: { type: :string },
                 return_price: { type: :string },
                 points: { type: :integer },
                 percent_date: { type: :string },
                 percent: { type: :string },
                 percent_value: { type: :string },
                 sent_date: { type: :string },
                 partner_id: { type: :integer },
               } }
        run_test!
      end

      response 422, "partner_id is required" do
        auth_api
        let(:partner_id) { "invalid" }
        run_test!
      end
    end
  end

  path "/commissions" do
    post "Creates a commission" do
      tags "Commissions"
      consumes "application/json"
      params_auth

      parameter name: :commission, in: :body, schema: {
        type: :object,
        properties: {
          order_id: { type: :string, example: 1 },
          order_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          client_name: { type: :string, example: Faker::Name.name },
          order_price: { type: :string, example: Faker::Number.decimal(0, 2) },
          return_price: { type: :string, example: Faker::Number.decimal(0, 2) },
          points: { type: :string, example: Faker::Number.number(3) },
          percent_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          percent: { type: :string, example: Faker::Number.decimal(0, 2) },
          percent_value: { type: :string, example: Faker::Number.decimal(0, 2) },
          sent_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          partner_id: { type: :string, example: 1 },
        },
        required: ["partner_id"],
      }

      response 201, "commission created" do
        auth_api
        let(:commission) { attributes_for(:commission) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:commission) { { name: nil } }
        run_test!
      end
    end
  end

  path "/commissions/by_year/{partner_id}/{year}" do
    get "retrives a commissions by year of partner" do
      tags "Commissions"
      consumes "application/json"
      params_auth
      parameter name: :partner_id, :in => :path, :type => :string, required: true
      parameter name: :year, :in => :path, :type => :string, required: true

      response 200, "commission found" do
        auth_api
        let(:commissions) { FactoryBot.create_list(:commission, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 order_id: { type: :integer },
                 order_date: { type: :string },
                 client_name: { type: :string },
                 order_price: { type: :string },
                 return_price: { type: :string },
                 points: { type: :integer },
                 percent_date: { type: :string },
                 percent: { type: :string },
                 percent_value: { type: :string },
                 sent_date: { type: :string },
                 partner_id: { type: :integer },
               } }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        let(:commission) { { name: nil } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:commission) { { name: nil } }
        let(:id) { create(:commission).id }
        run_test!
      end
    end
  end

  path "/commissions/consolidated_by_year/{year}" do
    get "retrives a commissions consolidated by year" do
      tags "Commissions"
      consumes "application/json"
      params_auth
      parameter name: :year, :in => :path, :type => :string, required: true

      response 200, "commission found" do
        auth_api
        let(:commissions) { FactoryBot.create_list(:commission, 5) }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :string },
                 nome_parceiro: { type: :string },
                 janeiro: { type: :string },
                 fevereiro: { type: :string },
                 marco: { type: :string },
                 abril: { type: :string },
                 maio: { type: :string },
                 junho: { type: :string },
                 julho: { type: :string },
                 agosto: { type: :string },
                 setembro: { type: :string },
                 outubro: { type: :string },
                 novembro: { type: :string },
                 dezembro: { type: :string },
               } }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        let(:commission) { { name: nil } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:commission) { { name: nil } }
        let(:id) { create(:commission).id }
        run_test!
      end
    end
  end

  path "/commissions/{id}" do
    put "Updates a commission" do
      tags "Commissions"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :commission, in: :body, schema: {
        type: :object,
        properties: {
          order_id: { type: :integer, example: 1 },
          order_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          client_name: { type: :string, example: Faker::Name.name },
          order_price: { type: :string, example: Faker::Number.decimal(0, 2) },
          return_price: { type: :string, example: Faker::Number.decimal(0, 2) },
          points: { type: :string, example: Faker::Number.number(3) },
          percent_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          percent: { type: :string, example: Faker::Number.decimal(0, 2) },
          percent_value: { type: :string, example: Faker::Number.decimal(0, 2) },
          sent_date: { type: :string, example: Faker::Date.birthday(18, 65) },
          partner_id: { type: :integer, example: 1 },
        },
        required: ["partner_id"],
      }

      response 200, "commission updated" do
        auth_api
        let(:commission) { { name: "newname" } }
        let(:id) { create(:commission).id }
        run_test!
      end

      response 404, "Not Found" do
        auth_api
        let(:id) { "invalid" }
        let(:commission) { { name: nil } }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:commission) { { name: nil } }
        let(:id) { create(:commission).id }
        run_test!
      end
    end
  end

  path "/commissions/{id}" do
    delete "Destroy a commission" do
      tags "Commissions"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 204, "commission destroyed" do
        auth_api
        let(:id) { create(:commission).id }
        run_test!
      end

      response 404, "invalid request" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/commissions/destroy_all/{partner_id}" do
    delete "Destroy a commission" do
      tags "Commissions"
      consumes "application/json"
      params_auth
      parameter name: :partner_id, :in => :path, :type => :string, required: true

      response 204, "commission destroyed" do
        auth_api
        let(:partner_id) { create(:commission).partner_id }
        run_test!
      end

      response 422, "partner_id is required" do
        auth_api
        let(:partner_id) { "invalid" }
        run_test!
      end
    end
  end
end
