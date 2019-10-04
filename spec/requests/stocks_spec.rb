require "rails_helper"

RSpec.describe "Stock API", type: :request do
  before do
    @api = create(:api)
    @stocks = create_list(:stock, 5)
    @stock = @stocks.first
    @stock_id = @stock.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /stocks" do
    before do
      get "/stocks#{@auth_data}", params: {}
    end
    it "return 5 company products from database" do
      expect(json_body.count).to eq(15)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /stocks/:id" do
    before do
      get "/stocks/#{@stock_id}#{@auth_data}", params: {}
    end

    it "return company product from database" do
      expect(json_body[:stock]).to eq(@stock.stock)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /stocks/:id" do
    before do
      put "/stocks/#{@stock_id}#{@auth_data}", params: stock_params
    end

    context "when the request params are valid" do
      let(:stock_params) { { stock_max: 25 } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated company product" do
        expect(json_body[:stock_max]).to eq(stock_params[:stock_max])
      end
    end

    context "when the request params are invalid" do
      let(:stock_params) { { stock_max: nil } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
