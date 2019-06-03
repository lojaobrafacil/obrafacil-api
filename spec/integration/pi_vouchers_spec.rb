require "swagger_helper"

describe "PiVouchers API" do
  path "/pi_vouchers" do
    get "All a pi_vouchers" do
      tags "PiVouchers"
      produces "application/json"
      params_auth
      parameter name: :page, in: :query, type: :string, description: "page number", required: false
      parameter name: :"per-page", in: :query, type: :string, description: "itens per page", required: false
      parameter name: :"partner_id", in: :query, type: :string, description: "id of partner", required: false

      response 200, "Premio ideal voucher found" do
        auth_api
        let(:partner_id) { create_list(:pi_voucher, 5).last.partner_id }
        schema type: :array,
               items: { type: :object, properties: {
                 id: { type: :integer },
                 expiration_date: { type: :string },
                 value: { type: :string },
                 used_at: { type: :string, 'x-nullable': true },
                 status: { type: :string },
                 received_at: { type: :string, 'x-nullable': true },
                 send_email_at: { type: :string, 'x-nullable': true },
                 attachment_url: { type: :string },
                 created_at: { type: :string },
                 updated_at: { type: :string },
                 company: { type: :object, properties: {
                   id: { type: :integer },
                   name: { type: :string },
                 } },
                 partner: { type: :object, properties: {
                   id: { type: :integer },
                   name: { type: :string },
                 } },
               } }
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
            id: { type: :integer },
            expiration_date: { type: :string },
            value: { type: :string },
            used_at: { type: :string, 'x-nullable': true },
            status: { type: :string },
            received_at: { type: :string, 'x-nullable': true },
            send_email_at: { type: :string, 'x-nullable': true },
            attachment_url: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            company: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
            partner: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
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
          status: { type: :string, example: "used, active or inactive" },
          received_at: { type: :string, example: Faker::Date.birthday(18, 65) },
          used_at: { type: :string, example: Faker::Date.forward(1) },
          value: { type: :string, example: Faker::Number.number(4) },
          company_id: { type: :integer },
          partner_id: { type: :integer },
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
        let(:pi_voucher) { { value: nil } }
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}/inactivate" do
    put "inactivate a pi_voucher" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "Premio ideal voucher inactivated" do
        auth_api
        let(:id) { create(:pi_voucher, status: "active", received_at: nil).id }
        run_test!
      end

      response 422, "voucher is already inactive" do
        auth_api
        let(:id) { create(:pi_voucher, status: "inactive").id }
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}/use" do
    put "use a pi_voucher" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :pi_voucher, in: :body, schema: {
        type: :object,
        properties: {
          company_id: { type: :integer },
        },
        required: ["company_id"],
      }

      response 200, "Premio ideal voucher used" do
        auth_api
        let(:pi_voucher) { { company_id: create(:company).id } }
        let(:id) { create(:pi_voucher, status: "active", received_at: nil).id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            expiration_date: { type: :string },
            value: { type: :string },
            used_at: { type: :string, 'x-nullable': true },
            status: { type: :string },
            received_at: { type: :string, 'x-nullable': true },
            send_email_at: { type: :string, 'x-nullable': true },
            attachment_url: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            company: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
            partner: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
          }
        run_test!
      end

      response 422, "voucher is already used" do
        auth_api
        let(:pi_voucher) { { company_id: nil } }
        let(:id) { create(:pi_voucher, status: "used", company_id: nil).id }
        schema type: :object,
          properties: {
            errors: {
              type: :object, properties: {
                status: { type: :array },
              },
            },
          }
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}/received" do
    put "received a pi_voucher" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "Premio ideal voucher received" do
        auth_api
        let(:id) { create(:pi_voucher, status: "active", received_at: nil).id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            expiration_date: { type: :string },
            value: { type: :string },
            used_at: { type: :string, 'x-nullable': true },
            status: { type: :string },
            received_at: { type: :string, 'x-nullable': true },
            send_email_at: { type: :string, 'x-nullable': true },
            attachment_url: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            company: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
            partner: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
          }
        run_test!
      end

      response 422, "voucher is already received" do
        auth_api
        let(:id) { create(:pi_voucher, received_at: Time.now - 1.hour).id }
        schema type: :object,
               properties: {
                 errors: {
                   type: :object, properties: {
                     status: { type: :array },
                   },
                 },
               }
        run_test!
      end
    end
  end

  path "/pi_vouchers/{id}/send_email" do
    post "send email a partner" do
      tags "PiVouchers"
      consumes "application/json"
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, "Email will be sent by background job" do
        auth_api
        let(:id) { create(:pi_voucher).id }
        schema type: :object,
          properties: {
            id: { type: :integer },
            expiration_date: { type: :string },
            value: { type: :string },
            used_at: { type: :string, 'x-nullable': true },
            status: { type: :string },
            received_at: { type: :string, 'x-nullable': true },
            send_email_at: { type: :string, 'x-nullable': true },
            attachment_url: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string },
            company: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
            partner: { type: :object, properties: {
              id: { type: :integer },
              name: { type: :string },
            } },
          }
        run_test!
      end

      response 422, "voucher is inactive or used" do
        auth_api
        let(:id) { create(:pi_voucher, status: "used", received_at: Time.now - 1.hour).id }

        schema type: :object,
               properties: {
                 errors: {
                   type: :object, properties: {
                     status: { type: :array },
                   },
                 },
               }
        run_test!
      end
    end
  end
end
