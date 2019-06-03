require "rails_helper"

RSpec.describe "State API", type: :request do
  before do
    @api = create(:api)
    @states = create_list(:state, 5)
    @state = @states.first
    @state_id = @state.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /states" do
    before do
      get "/states#{@auth_data}", params: {}
    end
    it "return 5 states from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /states/:id" do
    before do
      get "/states/#{@state_id}#{@auth_data}", params: {}
    end
    it "return state from database" do
      expect(json_body.size).to eq(Api::StateSerializer.new(@state).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /states" do
    before do
      post "/states#{@auth_data}", params: state_params
    end

    context "when the request params are valid" do
      let(:state_params) { attributes_for(:state) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created state" do
        expect(json_body[:name]).to eq(state_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:state_params) { {name: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /states/:id" do
    before do
      put "/states/#{@state_id}#{@auth_data}", params: state_params
    end

    context "when the request params are valid" do
      let(:state_params) { {name: "Novo"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated state" do
        expect(json_body[:name]).to eq(state_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:state_params) { {name: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /states/:id" do
    before do
      delete "/states/#{@state_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(State.find_by(id: @state_id)).to be_nil
    end
  end
end
