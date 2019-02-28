require "swagger_helper"

describe "PiVouchers API" do
  path "/pi_vouchers" do
    get "All a pi_vouchers" do
      tags "PiVouchers"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false

      response 200, "Premio ideal voucher found" do
        auth_api
        let(:pi_voucher) { create_list(:pi_voucher, 5) }
        schema type: :array,
               items: {type: :object, properties: {
                 id: {type: :string},
                 expiration_date: {type: :string},
                 value: {type: :float},
                 used_at: {type: :string},
                 status: {type: :string},
                 received_at: {type: :string},
                 created_at: {type: :string},
                 updated_at: {type: :string},
                 company: {type: :object, properties: {
                   id: {type: :integer},
                   name: {type: :string},
                 }},
                 partner: {type: :object, properties: {
                   id: {type: :integer},
                   name: {type: :string},
                 }},
               }}
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}" do
    get "Retrieves a pi_voucher" do
      tags "PiVouchers"
      produces "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "Premio ideal voucher found" do
        auth_api
        schema type: :object,
          properties: {
            id: {type: :string},
            expiration_date: {type: :string},
            value: {type: :float},
            used_at: {type: :string},
            status: {type: :string},
            received_at: {type: :string},
            created_at: {type: :string},
            updated_at: {type: :string},
            company: {type: :object, properties: {
              id: {type: :integer},
              name: {type: :string},
            }},
            partner: {type: :object, properties: {
              id: {type: :integer},
              name: {type: :string},
            }},
          }

        let(:id) { create(:pi_voucher).id }
        run_test!
      end

      response 404, "Premio ideal voucher not found" do
        auth_api
        let(:id) { "invalid" }
        run_test!
      end
    end
  end

  path "/pi_vouchers" do
    post "Creates a pi_voucher" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth

      parameter name: :pi_voucher, in: :body, schema: {
        type: :object,
        properties: {
          status: {type: :string, example: "used, active or inactive"},
          received_at: {type: :string, example: Faker::Date.birthday(18, 65)},
          used_at: {type: :string, example: Faker::Date.forward(1)},
          value: {type: :string, example: Faker::Number.number(4)},
          company_id: {type: :integer},
          partner_id: {type: :integer},
        },
        required: ["value", "partner_id"],
      }

      response 201, "Premio ideal voucher created" do
        auth_api
        let(:pi_voucher) { attributes_for(:pi_voucher) }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:pi_voucher) { {name: "foo"} }
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}" do
    put "Updates a pi_voucher" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :pi_voucher, in: :body, schema: {
        type: :object,
        properties: {
          status: {type: :string, example: "used, active or inactive"},
          received_at: {type: :string, example: Faker::Date.birthday(18, 65)},
          used_at: {type: :string, example: Faker::Date.forward(1)},
          value: {type: :string, example: Faker::Number.number(4)},
          company_id: {type: :integer},
          partner_id: {type: :integer},
        },
        required: ["value", "partner_id"],
      }

      response 200, "Premio ideal voucher updated" do
        auth_api
        let(:pi_voucher) { {name: "newname"} }
        let(:id) { create(:pi_voucher).id }
        run_test!
      end

      response 422, "invalid request" do
        auth_api
        let(:pi_voucher) { {name: nil} }
        let(:id) { create(:pi_voucher).id }
        run_test!
      end
    end
  end
end
