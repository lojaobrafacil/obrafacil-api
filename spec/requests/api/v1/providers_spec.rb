require 'rails_helper'

RSpec.describe 'Provider API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:providers) { create_list(:provider, 5) }
  let(:provider) { providers.first }
  let(:provider_id) { provider.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /providers' do
    before do
      get '/providers', params: {}, headers: headers
    end
    it 'return 5 providers from database' do
      expect(json_body[:providers].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /providers/:id' do
    before do
      get "/providers/#{provider_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body.to_json).to eq(provider.to_json)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /providers' do
    before do
      post '/providers', params: { provider: provider_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:provider_params) { attributes_for(:provider) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created provider' do
        expect(json_body[:name]).to eq(provider_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:provider_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /providers/:id' do
    before do
      put "/providers/#{provider_id}", params: { provider: provider_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:provider_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated provider' do
        expect(json_body[:name]).to eq(provider_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:provider_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /providers/:id' do
    before do
      delete "/providers/#{provider_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Provider.find_by(id: provider_id)).to be_nil
    end
  end
end
