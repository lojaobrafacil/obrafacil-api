require 'rails_helper'

RSpec.describe 'PaymentMethod API', type: :request do
  let!(:user){ create(:employee, admin:true) }
  let!(:payment_methods) { create_list(:payment_method, 5) }
  let(:payment_method) { payment_methods.first }
  let(:payment_method_id) { payment_method.id }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v2',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /admin/payment_methods' do
    before do
      get '/admin/payment_methods', params: {}, headers: headers
    end
    it 'return 5 payment_methods from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/payment_methods/:id' do
    before do
      get "/admin/payment_methods/#{payment_method_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(payment_method[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /admin/payment_methods' do
    before do
      post '/admin/payment_methods', params: payment_method_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:payment_method_params) { attributes_for(:payment_method) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created payment_method' do
        expect(json_body[:name]).to eq(payment_method_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:payment_method_params) { { name:nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /admin/payment_methods/:id' do
    before do
      put "/admin/payment_methods/#{payment_method_id}", params: payment_method_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:payment_method_params) { { name: 'jorge' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated payment_method' do
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

  describe 'DELETE /admin/payment_methods/:id' do
    before do
      delete "/admin/payment_methods/#{payment_method_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(PaymentMethod.find_by(id: payment_method_id)).to be_nil
    end
  end
end
