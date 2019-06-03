require "rails_helper"

RSpec.describe "Ibpt API", type: :request do
  before do
    @api = create(:api)
    @ibpts = create_list(:ibpt, 5)
    @ibpt = @ibpts.first
    @ibpt_id = @ibpt.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /ibpts" do
    before do
      get "/ibpts#{@auth_data}", params: {}
    end
    it "return 5 ibpts from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /ibpts/:id" do
    before do
      get "/ibpts/#{@ibpt_id}#{@auth_data}", params: {}
    end
    it "return ibpt from database" do
      expect(json_body.size).to eq(Api::IbptSerializer.new(@ibpt).as_json.size)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /ibpts" do
    before do
      post "/ibpts#{@auth_data}", params: ibpt_params
    end

    context "when the request params are valid" do
      let(:ibpt_params) { attributes_for(:ibpt) }

      it "return status code 201" do
        expect(response).to have_http_status(201)
      end

      it "returns the json data for the created ibpt" do
        expect(json_body[:code].to_s).to eq(ibpt_params[:code].to_s)
      end
    end

    context "when the request params are invalid" do
      let(:ibpt_params) { {code: ""} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "PUT /ibpts/:id" do
    before do
      put "/ibpts/#{@ibpt_id}#{@auth_data}", params: ibpt_params
    end

    context "when the request params are valid" do
      let(:ibpt_params) { {code: "844"} }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated ibpt" do
        expect(json_body[:code].to_s).to eq(ibpt_params[:code].to_s)
      end
    end

    context "when the request params are invalid" do
      let(:ibpt_params) { {code: nil} }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe "DELETE /ibpts/:id" do
    before do
      delete "/ibpts/#{@ibpt_id}#{@auth_data}", params: {}.to_json
    end

    it "return status code 204" do
      expect(response).to have_http_status(204)
    end

    it "removes the user from database" do
      expect(Ibpt.find_by(id: @ibpt_id)).to be_nil
    end
  end
end
