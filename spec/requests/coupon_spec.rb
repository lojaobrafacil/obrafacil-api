require "rails_helper"

RSpec.describe "Coupon API", type: :request do
  before do
    @api = create(:api)
    @coupons = create_list(:coupon, 5)
    @coupon = @coupons.first
    @coupon_id = @coupon.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe "GET /coupons" do
    before do
      get "/coupons#{@auth_data}", params: {}
    end
    it "return 5 company products from database" do
      expect(json_body.count).to eq(5)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /coupons/:id" do
    before do
      get "/coupons/#{@coupon_id}#{@auth_data}", params: {}
    end

    it "return company product from database" do
      expect(json_body[:id]).to eq(@coupon.id)
    end

    it "return status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "PUT /coupons/:id" do
    before do
      put "/coupons/#{@coupon_id}#{@auth_data}", params: coupon_params
    end

    context "when the request params are valid" do
      let(:coupon_params) { { name: "25" } }

      it "return status code 200" do
        expect(response).to have_http_status(200)
      end

      it "return the json data for the updated company product" do
        expect(json_body[:name]).to eq(coupon_params[:name])
      end
    end

    context "when the request params are invalid" do
      let(:coupon_params) { { name: nil } }

      it "return status code 422" do
        expect(response).to have_http_status(422)
      end

      it "return the json data for the errors" do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
