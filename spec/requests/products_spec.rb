require 'rails_helper'

RSpec.describe 'Product API', type: :request do
  before do 
    @api = create(:api)
    @products = create_list(:product, 5)
    @product = @products.first
    @product_id = @product.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /products' do
    before do
      get "/products#{@auth_data}", params: {}
    end
    it 'return 5 phone types from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /products/:id' do
    before do
      get "/products/#{@product_id}#{@auth_data}", params: {}
    end
    it 'return phone type from database' do
      expect(json_body.size).to eq(Api::ProductSerializer.new(@product).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /products' do
    before do
      post "/products#{@auth_data}", params: product_params 
    end

    context 'when the request params are valid' do
      let(:product_params) { attributes_for(:product) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created phone type' do
        expect(json_body[:name]).to eq(product_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:product_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /products/:id' do
    before do
      put "/products/#{@product_id}#{@auth_data}", params: product_params 
    end

    context 'when the request params are valid' do
      let(:product_params) { { name: "Novo" } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated phone type' do
        expect(json_body[:name]).to eq(product_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:product_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /products/:id' do
    before do
      delete "/products/#{@product_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Product.find_by(id: @product_id)).to be_nil
    end
  end
end
