require "rails_helper"

RSpec.describe "Region API", type: :request do
  before do
    @api = create(:api)
    @regions = create_list(:region, 5)
    @region = @regions.first
    @region_id = @region.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /regions" do
    before do
      get "/regions#{@auth_data}", params: {}
    end
    it "return 5 regions from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /regions/:id" do
    before do
      get "/regions/#{@region_id}#{@auth_data}", params: {}
    end
    it "return region from database" do
      expect(json_body.size).to eq(Api::RegionSerializer.new(@region).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /regions" do
    before do
      post "/regions#{@auth_data}", params: region_params
    end

    context "when the request params are valid" do
      let(:region_params) { attributes_for(:region) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created region" do
        expect(json_body[:name]).to eq(region_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:region_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /regions/:id" do
    before do
      put "/regions/#{@region_id}#{@auth_data}", params: region_params
    end

    context "when the request params are valid" do
      let(:region_params) { {name: "Novo"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated region" do
        expect(json_body[:name]).to eq(region_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:region_params) { {name: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /regions/:id" do
    before do
      delete "/regions/#{@region_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Region.find_by(id: @region_id)).to be_nil
    end
  end
end
