require "rails_helper"

RSpec.describe "PhoneType API", type: :request do
  before do
    @api = create(:api)
    @phone_types = create_list(:phone_type, 5)
    @phone_type = @phone_types.first
    @phone_type_id = @phone_type.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /phone_types" do
    before do
      get "/phone_types#{@auth_data}", params: {}
    end
    it "return 5 phone types from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /phone_types/:id" do
    before do
      get "/phone_types/#{@phone_type_id}#{@auth_data}", params: {}
    end
    it "return phone type from database" do
      expect(json_body.size).to eq(Api::PhoneTypeSerializer.new(@phone_type).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /phone_types" do
    before do
      post "/phone_types#{@auth_data}", params: phone_type_params
    end

    context "when the request params are valid" do
      let(:phone_type_params) { attributes_for(:phone_type) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created phone type" do
        expect(json_body[:name]).to eq(phone_type_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:phone_type_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /phone_types/:id" do
    before do
      put "/phone_types/#{@phone_type_id}#{@auth_data}", params: phone_type_params
    end

    context "when the request params are valid" do
      let(:phone_type_params) { {name: "Novo"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated phone type" do
        expect(json_body[:name]).to eq(phone_type_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:phone_type_params) { {name: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /phone_types/:id" do
    before do
      delete "/phone_types/#{@phone_type_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(PhoneType.find_by(id: @phone_type_id)).to be_nil
    end
  end
end
