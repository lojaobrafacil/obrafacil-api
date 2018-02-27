require 'rails_helper'

RSpec.describe 'Client API', type: :request do
  let!(:user){ create(:user) }
  let!(:clients) { create_list(:client, 5) }
  let(:client) { clients.first }
  let(:client_id) { client.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /clients' do
    before do
      get '/clients', params: {}, headers: headers
    end
    it 'return 5 clients from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /clients/:id' do
    before do
      get "/clients/#{client_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(client.name)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /clients' do
    before do
      post '/clients', params: { client: client_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:client_params) { attributes_for(:client) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created client' do
        expect(json_body[:name]).to eq(client_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:client_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /clients/:id' do
    before do
      put "/clients/#{client_id}", params: { client: client_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:client_params) { { name: 'jorge' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated client' do
        expect(json_body[:name]).to eq(client_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:client_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /clients/:id' do
    before do
      delete "/clients/#{client_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Client.find_by(id: client_id)).to be_nil
    end
  end
end
