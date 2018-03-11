require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do  
  let!(:user){ create(:user) }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s
    }
  end
  describe 'POST /sessions' do
    before do
    	post '/sessions', params: {session: credencials}.to_json, headers: headers
    end

    context 'when the credencials are correct' do
      let(:credencials) {{federal_registration: user.federal_registration, password: '12345678'}}

      it 'return status code 200' do
        expect(response).to have_http_status(200) 
      end

      it 'returns the authentication data in the headers' do
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
      end
    end
    context 'returns the json data for the errors' do
      let(:credencials) { { federal_registration: user.federal_registration, password: 'invalid_password' } }

      it 'when credencials are incorrect' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  
  describe 'DELETE /sessions/:id' do
    let(:auth_token) { user.auth_token }
    before do
      delete "/sessions/#{auth_token}", params: { }, headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'changes the user auth token' do
      user.reload
      expect( User.find_by(auth_token: auth_token) ).to be_nil
    end
  end
end
