require 'rails_helper'

RSpec.describe 'PaymentMethod API', type: :request do
  before do 
    @api = create(:api)
    @payment_methods = create_list(:payment_method, 5)
    @payment_method = @payment_methods.first
    @payment_method_id = @payment_method.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /payment_methods' do
    before do
      get "/payment_methods#{@auth_data}", params: {}
    end
    it 'return 5 payment methods from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /payment_methods/:id' do
    before do
      get "/payment_methods/#{@payment_method_id}#{@auth_data}", params: {}
    end
    it 'return payment method from database' do
      expect(json_body.size).to eq(Api::PaymentMethodSerializer.new(@payment_method).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /payment_methods' do
    before do
      post "/payment_methods#{@auth_data}", params: payment_method_params 
    end

    context 'when the request params are valid' do
      let(:payment_method_params) { attributes_for(:payment_method) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created payment method' do
        expect(json_body[:name]).to eq(payment_method_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:payment_method_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /payment_methods/:id' do
    before do
      put "/payment_methods/#{@payment_method_id}#{@auth_data}", params: payment_method_params 
    end

    context 'when the request params are valid' do
      let(:payment_method_params) { { name: "Novo" } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated payment method' do
        expect(json_body[:name]).to eq(payment_method_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:payment_method_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /payment_methods/:id' do
    before do
      delete "/payment_methods/#{@payment_method_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(PaymentMethod.find_by(id: @payment_method_id)).to be_nil
    end
  end
end
