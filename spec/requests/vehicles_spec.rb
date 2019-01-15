require "rails_helper"

RSpec.describe "Vehicle API", type: :request do
  before do
    @api = create(:api)
    @vehicles = create_list(:vehicle, 5)
    @vehicle = @vehicles.first
    @vehicle_id = @vehicle.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /vehicles" do
    before do
      get "/vehicles#{@auth_data}", params: {}
    end
    it "return 5 vehicles from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /vehicles/:id" do
    before do
      get "/vehicles/#{@vehicle_id}#{@auth_data}", params: {}
    end
    it "return vehicle from database" do
      expect(json_body.size).to eq(Api::VehicleSerializer.new(@vehicle).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /vehicles" do
    before do
      post "/vehicles#{@auth_data}", params: vehicle_params
    end

    context "when the request params are valid" do
      let(:vehicle_params) { attributes_for(:vehicle) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created vehicle" do
        expect(json_body[:model]).to eq(vehicle_params[:model])
      end
    end

    context "when the request params are invalid" do
      let(:vehicle_params) { {model: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /vehicles/:id" do
    before do
      put "/vehicles/#{@vehicle_id}#{@auth_data}", params: vehicle_params
    end

    context "when the request params are valid" do
      let(:vehicle_params) { {model: "Novo"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated vehicle" do
        expect(json_body[:model]).to eq(vehicle_params[:model])
      end
    end

    context "when the request params are invalid" do
      let(:vehicle_params) { {model: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /vehicles/:id" do
    before do
      delete "/vehicles/#{@vehicle_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Vehicle.find_by(id: @vehicle_id)).to be_nil
    end
  end
end
