require 'rails_helper'

RSpec.describe 'Order API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:orders) { create_list(:order, 5) }
  let(:order) { orders.first }
  let(:order_id) { order.id }
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

  describe 'GET /orders' do
    before do
      get '/admin/orders', params: {}, headers: headers
    end
    it 'return 5 orders from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /orders/:id' do
    before do
      get '/admin/orders/#{order_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:description]).to eq(order[:description])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /orders' do
    before do
      post '/admin/orders', params: { order: order_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:order_params) { attributes_for(:order) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created order' do
        expect(json_body[:description]).to eq(order_params[:description])
      end
    end

    context 'when the request params are invalid' do
      let(:order_params) { { kind: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /orders/:id' do
    before do
      Order.find(order_id).update!(kind: 0)
      put '/admin/orders/#{order_id}', params: { order: order_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:order_params) { { kind: 'normal' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated order' do
        expect(json_body[:kind]).to eq(order_params[:kind])
      end
    end

    context 'when the request params are invalid' do
      let(:order_params) { { kind: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /orders/:id' do
    before do
      delete '/admin/orders/#{order_id}', params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Order.find_by(id: order_id)).to be_nil
    end
  end
end
