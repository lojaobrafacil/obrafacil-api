require 'rails_helper'

RSpec.describe 'Carrier API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:carriers) { create_list(:carrier, 5) }
  let(:carrier) { carriers.first }
  let(:carrier_id) { carrier.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /carriers' do
    before do
      get '/carriers', params: {}, headers: headers
    end
    it 'return 5 carriers from database' do
      expect(json_body[:data].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /carriers/:id' do
    before do
      get "/carriers/#{carrier_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:data][:attributes][:name]).to eq(carrier.name)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /carriers' do
    before do
      post '/carriers', params: { carrier: carrier_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:carrier_params) { attributes_for(:carrier) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created carrier' do
        expect(json_body[:data][:attributes][:name]).to eq(carrier_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:carrier_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /carriers/:id' do
    before do
      put "/carriers/#{carrier_id}", params: { carrier: carrier_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:carrier_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated carrier' do
        expect(json_body[:data][:attributes][:name]).to eq(carrier_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:carrier_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /carriers/:id' do
    before do
      delete "/carriers/#{carrier_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Carrier.find_by(id: carrier_id)).to be_nil
    end
  end
end
