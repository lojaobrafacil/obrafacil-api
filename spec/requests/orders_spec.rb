require 'rails_helper'

RSpec.describe 'Order API', type: :request do
  before do 
    @api = create(:api)
    @orders = create_list(:order, 5)
    @order = @orders.first
    @order_id = @order.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /orders' do
    before do
      get "/orders#{@auth_data}", params: {}
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
      get "/orders/#{@order_id}#{@auth_data}", params: {}
    end
    it 'return order from database' do
      expect(json_body.size).to eq(Api::OrderSerializer.new(@order).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /orders' do
    before do
      post "/orders#{@auth_data}", params: order_params 
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
      let(:order_params) { { description: '' } }

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
      put "/orders/#{@order_id}#{@auth_data}", params: order_params 
    end

    context 'when the request params are valid' do
      let(:order_params) { { kind: "budget" } }

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
      delete "/orders/#{@order_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Order.find_by(id: @order_id)).to be_nil
    end
  end
end
