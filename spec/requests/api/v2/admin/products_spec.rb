require 'rails_helper'

RSpec.describe 'Product API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:products) { create_list(:product, 5) }
  let(:product) { products.first }
  let(:product_id) { product.id }
  let(:auth_data) { auth.create_new_auth_token }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v2',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /products' do
    before do
      get '/admin/products', params: {}, headers: headers
    end
    it 'return 5 products from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /products/:id' do
    before do
      get '/admin/products/#{product_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(product[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /products' do
    before do
      post '/admin/products', params: { product: product_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:product_params) { attributes_for(:product) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created product' do
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
      put '/admin/products/#{product_id}', params: { product: product_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:product_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated product' do
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
      delete '/admin/products/#{product_id}', params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Product.find_by(id: product_id)).to be_nil
    end
  end
end
