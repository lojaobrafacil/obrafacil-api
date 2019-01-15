require "rails_helper"

RSpec.describe "AddressType API", type: :request do
  before do
    @api = create(:api)
    @address_types = create_list(:address_type, 5)
    @address_type = @address_types.first
    @address_type_id = @address_type.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /address_types" do
    before do
      get "/address_types#{@auth_data}", params: {}
    end
    it "return 5 address types from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /address_types/:id" do
    before do
      get "/address_types/#{@address_type_id}#{@auth_data}", params: {}
    end
    it "return address type from database" do
      expect(json_body.size).to eq(Api::AddressTypeSerializer.new(@address_type).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /address_types" do
    before do
      post "/address_types#{@auth_data}", params: address_type_params
    end

    context "when the request params are valid" do
      let(:address_type_params) { attributes_for(:address_type) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created address type" do
        expect(json_body[:name]).to eq(address_type_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:address_type_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /address_types/:id" do
    before do
      put "/address_types/#{@address_type_id}#{@auth_data}", params: address_type_params
    end

    context "when the request params are valid" do
      let(:address_type_params) { {name: "Comercial"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated address type" do
        expect(json_body[:name]).to eq(address_type_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:address_type_params) { {name: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /address_types/:id" do
    before do
      delete "/address_types/#{@address_type_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(AddressType.find_by(id: @address_type_id)).to be_nil
    end
  end
end
