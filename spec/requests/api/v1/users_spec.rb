require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns the user' do
        expect(json_body[:data][:id]).to eq(user_id.to_s)
      end

      it 'returns status 200' do
        expect(response).to have_http_status(200)
      end
    end
    context 'returns status does not exist' do
      let(:user_id) { 99999 }

      it 'returns status code 400' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe "POST /users" do
    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid_email@'} }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do

      let(:user_params) { {email:'new_email@emam.com'} }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated user' do
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
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
  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: { }, headers: headers
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end
