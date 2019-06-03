require "rails_helper"

RSpec.describe "Cfop API", type: :request do
  before do
    @api = create(:api)
    @cfops = create_list(:cfop, 5)
    @cfop = @cfops.first
    @cfop_id = @cfop.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /cfops" do
    before do
      get "/cfops#{@auth_data}", params: {}
    end
    it "return 5 cfops from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /cfops/:id" do
    before do
      get "/cfops/#{@cfop_id}#{@auth_data}", params: {}
    end
    it "return cfop from database" do
      expect(json_body.size).to eq(Api::CfopSerializer.new(@cfop).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /cfops" do
    before do
      post "/cfops#{@auth_data}", params: cfop_params
    end

    context "when the request params are valid" do
      let(:cfop_params) { attributes_for(:cfop) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created cfop" do
        expect(json_body[:name]).to eq(cfop_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:cfop_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /cfops/:id" do
    before do
      put "/cfops/#{@cfop_id}#{@auth_data}", params: cfop_params
    end

    context "when the request params are valid" do
      let(:cfop_params) { {code: 200} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated cfop" do
        expect(json_body[:code]).to eq(cfop_params[:code])
      end
    end

    context "when the request params are invalid" do
      let(:cfop_params) { {code: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /cfops/:id" do
    before do
      delete "/cfops/#{@cfop_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Cfop.find_by(id: @cfop_id)).to be_nil
    end
  end
end
