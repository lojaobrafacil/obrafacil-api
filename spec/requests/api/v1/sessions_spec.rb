require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do  
  let!(:user){ create(:user) }
  let(:user_id) { user.id }
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
  describe 'POST /auth/sign_in' do
    before do
    	post '/auth/sign_in', params: credencials.to_json, headers: headers
    end

    context 'when the credencials are correct' do
      let(:credencials) { {email: user.email, password: '12345678'} }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the authentication data in the headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end
    end
    context 'returns the json data for the errors' do
      let(:credencials) { { email: user.email, password: 'invalid_password' } }

      it 'when credencials are incorrect' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  describe 'DELETE /auth/sign_out' do
    before do
      delete "/auth/sign_out", params: { }, headers: headers
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'changes the user auth token' do
      user.reload
      # expect(user.valid_token?(auth_data['access-token'], auth_data['client'])).to eq(false)
      expect( user ).not_to be_valid_token(auth_data['access-token'], auth_data['client'])
    end
  end
end
