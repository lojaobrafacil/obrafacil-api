require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:user){ create(:user) }
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

  describe 'GET /admin/auth/validate_token' do
    context 'when the user exists' do
      before do
        get "/admin/auth/validate_token", params: {}, headers: headers
      end
      it 'returns the request headers are valid' do
        expect(json_body[:data][:id]).to eq(user.id)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'returns the request headers are not valid' do
      before do
        headers['access-token'] = 'invalid_token'
        get "/admin/auth/validate_token", params: {}, headers: headers
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PUT /admin/auth' do
    before do
      put "/admin/auth", params: user_params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { {email:'new_email@emam.com'} }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do

      let(:user_params) { {email:'invalid_email@'} }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
  describe 'DELETE /admin/auth' do
    before do
      delete "/admin/auth", params: {  }, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'removes the user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end
