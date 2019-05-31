require "rails_helper"

RSpec.describe "Client API", type: :request do
  before do
    @api = create(:api)
    @clients = create_list(:client, 5)
    @client = @clients.first
    @client_id = @client.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /clients" do
    before do
      get "/clients#{@auth_data}", params: {}
    end
    it "return 5 clients from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /clients/:id" do
    before do
      get "/clients/#{@client_id}#{@auth_data}", params: {}
    end
    it "return client from database" do
      expect(json_body.size).to eq(Api::ClientSerializer.new(@client).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /clients" do
    before do
      post "/clients#{@auth_data}", params: client_params
    end

    context "when the request params are valid" do
      let(:client_params) { attributes_for(:client) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created client" do
        expect(json_body[:name]).to eq(client_params[:name].titleize)
      end
    end

    context "when the request params are invalid" do
      let(:client_params) { { name: "" } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /clients/:id" do
    before do
      put "/clients/#{@client_id}#{@auth_data}", params: client_params
    end

    context "when the request params are valid" do
      let(:client_params) { { name: "Arthur" } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated client" do
        expect(json_body[:name]).to eq(client_params[:name].titleize)
      end
    end

    context "when the request params are invalid" do
      let(:client_params) { { name: nil } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /clients/:id" do
    before do
      delete "/clients/#{@client_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 200" do
      expect(response).to have_http_status(200)
    end

    it "removes the user from database" do
      expect(Client.find_by(id: @client_id).status).to eq("deleted")
    end
  end
end
