require "rails_helper"

RSpec.describe "Partner API", type: :request do
  before do
    @api = Api.find_or_initialize_by(id: 1)
    @api.update(attributes_for(:api))
    @employee = Employee.find_or_initialize_by(id: 1)
    @employee.update(attributes_for(:employee))
    @partners = create_list(:partner, 5)
    @partner = @partners.first
    @partner_deleted = @partners.last
    @partner_deleted.update(deleted_by_id: @employee.id)
    @partner_id = @partner.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /partners" do
    before do
      get "/partners#{@auth_data}", params: {}
    end
    it "return 5 partners from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /partners/:id" do
    before do
      get "/partners/#{@partner_id}#{@auth_data}", params: {}
    end
    it "return partner from database" do
      expect(json_body.size).to eq(Api::PartnerSerializer.new(@partner).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /partners" do
    before do
      post "/partners#{@auth_data}", params: partner_params
    end

    context "when the request params are valid" do
      let(:partner_params) { attributes_for(:partner) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created partner" do
        expect(json_body[:name]).to eq(partner_params[:name].titleize)
      end
    end

    context "when the request params are invalid" do
      let(:partner_params) { { name: "" } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /partners/:id" do
    before do
      put "/partners/#{@partner_id}#{@auth_data}", params: partner_params
    end

    context "when the request params are valid" do
      let(:partner_params) { { name: "Novo" } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated partner" do
        expect(json_body[:name]).to eq(partner_params[:name].titleize)
      end
    end

    context "when the request params are invalid" do
      let(:partner_params) { { name: nil } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /partners/:id" do
    before do
      delete "/partners/#{@partner_deleted.id}#{@auth_data}"
    end

    it "return status code 200" do
      expect(response).to have_http_status(200)
    end

    it "removes the user from database" do
      expect(json_body).to eq({ success: I18n.t("models.partner.response.delete.success") })
    end
  end
end
