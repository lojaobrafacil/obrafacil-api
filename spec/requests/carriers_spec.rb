require "rails_helper"

RSpec.describe "Carrier API", type: :request do
  before do
    @api = create(:api)
    @carriers = create_list(:carrier, 5)
    @carrier = @carriers.first
    @carrier_id = @carrier.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /carriers" do
    before do
      get "/carriers#{@auth_data}", params: {}
    end
    it "return 5 carriers from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /carriers/:id" do
    before do
      get "/carriers/#{@carrier_id}#{@auth_data}", params: {}
    end
    it "return carrier from database" do
      expect(json_body.size).to eq(Api::CarrierSerializer.new(@carrier).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /carriers" do
    before do
      post "/carriers#{@auth_data}", params: carrier_params
    end

    context "when the request params are valid" do
      let(:carrier_params) { attributes_for(:carrier) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created carrier" do
        expect(json_body[:name]).to eq(carrier_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:carrier_params) { { name: "" } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /carriers/:id" do
    before do
      put "/carriers/#{@carrier_id}#{@auth_data}", params: carrier_params
    end

    context "when the request params are valid" do
      let(:carrier_params) { { name: "Comercial" } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated carrier" do
        expect(json_body[:name]).to eq(carrier_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:carrier_params) { { name: nil } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /carriers/:id" do
    before do
      delete "/carriers/#{@carrier_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Carrier.find_by(id: @carrier_id)).to be_nil
    end
  end
end
