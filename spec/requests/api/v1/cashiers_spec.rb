require 'rails_helper'

RSpec.describe 'Cashier API', type: :request do
  let!(:user){ create(:user) }
  let!(:cashiers) { create_list(:cashier, 5) }
  let(:cashier) { cashiers.first }
  let(:cashier_id) { cashier.id }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /cashiers' do
    before do
      get '/cashiers', params: {}, headers: headers
    end
    it 'return 5 cashiers from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /cashiers/:id' do
    before do
      get "/cashiers/#{cashier_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:start_date].to_s.to_time).to eq(cashier.start_date)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /cashiers' do
    before do
      post '/cashiers', params: { cashier: cashier_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:cashier_params) { attributes_for(:cashier) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created cashier' do
        expect(json_body[:start_date].to_time.strftime("%H:%M:%S %d-%m-%Y")).to eq(cashier_params[:start_date].to_time.strftime("%H:%M:%S %d-%m-%Y"))
      end
    end

    context 'when the request params are invalid' do
      let(:cashier_params) { { start_date: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /cashiers/:id' do
    before do
      put "/cashiers/#{cashier_id}", params: { cashier: cashier_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:cashier_params) { { start_date: Time.new + 1.hour } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated cashier' do
        expect(json_body[:start_date].to_time.strftime("%H:%M:%S %d-%m-%Y")).to eq(cashier_params[:start_date].to_time.strftime("%H:%M:%S %d-%m-%Y"))
      end
    end

    context 'when the request params are invalid' do
      let(:cashier_params) { { start_date: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /cashiers/:id' do
    before do
      delete "/cashiers/#{cashier_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Cashier.find_by(id: cashier_id)).to be_nil
    end
  end
end
