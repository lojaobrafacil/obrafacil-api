require "rails_helper"

RSpec.describe "Phone API", type: :request do
  before do
    @api = create(:api)
    @phones = create_list(:phone, 5)
    @phone = @phones.first
    @phone_id = @phone.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /phones" do
    before do
      get "/phones#{@auth_data}", params: {}
    end
    it "return 5 phones from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /phones/:id" do
    before do
      get "/phones/#{@phone_id}#{@auth_data}", params: {}
    end
    it "return phone from database" do
      expect(json_body.size).to eq(Api::PhoneSerializer.new(@phone).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /phones" do
    before do
      post "/phones#{@auth_data}", params: phone_params
    end

    context "when the request params are valid" do
      let(:phone_params) { attributes_for(:contact) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created phone" do
        expect(json_body[:contact]).to eq(phone_params[:contact])
      end
    end

    context "when the request params are invalid" do
      let(:phone_params) { {phone: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /phones/:id" do
    before do
      put "/phones/#{@phone_id}#{@auth_data}", params: phone_params
    end

    context "when the request params are valid" do
      let(:phone_params) { {phone: "+5511999999999"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated phone" do
        expect(json_body[:phone]).to eq("(11) 99999-9999")
      end
    end

    context "when the request params are invalid" do
      let(:phone_params) { {phone: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /phones/:id" do
    before do
      delete "/phones/#{@phone_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Phone.find_by(id: @phone_id)).to be_nil
    end
  end
end
