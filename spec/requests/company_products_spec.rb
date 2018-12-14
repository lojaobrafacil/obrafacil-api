require 'rails_helper'

RSpec.describe 'CompanyProduct API', type: :request do
  before do 
    @api = create(:api)
    @company_products = create_list(:company_product, 5)
    @company_product = @company_products.first
    @company_product_id = @company_product.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /company_products' do
    before do
      get "/company_products#{@auth_data}", params: {}
    end
    it 'return 5 company products from database' do
      expect(json_body.count).to eq(15)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /company_products/:id' do
    before do
      get "/company_products/#{@company_product_id}#{@auth_data}", params: {}
    end

    it 'return company product from database' do
      expect(json_body[:stock]).to eq(@company_product.stock)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /company_products/:id' do
    before do
      put "/company_products/#{@company_product_id}#{@auth_data}", params: company_product_params 
    end

    context 'when the request params are valid' do
      let(:company_product_params) { { stock: 25 } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated company product' do
        expect(json_body[:stock]).to eq(company_product_params[:stock])
      end
    end

    context 'when the request params are invalid' do
      let(:company_product_params) { { stock: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
