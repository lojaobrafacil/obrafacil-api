require 'rails_helper'

RSpec.describe 'Permission API', type: :request do
  let!(:user){ create(:user) }
  let!(:permissions) { create_list(:permission, 5) }
  let(:permission) { permissions.first }
  let(:permission_id) { permission.id }
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

  describe 'GET /permissions' do
    before do
      get '/permissions', params: {}, headers: headers
    end
    it 'return 5 address types from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /permissions/:id' do
    before do
      get "/permissions/#{permission_id}", params: {}, headers: headers
    end
    it 'return address type from database' do
      expect(json_body[:name]).to eq(permission[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /permissions' do
    before do
      post '/permissions', params: { permission: permission_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:permission_params) { attributes_for(:permission) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created address type' do
        expect(json_body[:name]).to eq(permission_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:permission_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /permissions/:id' do
    before do
      put "/permissions/#{permission_id}", params: { permission: permission_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:permission_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated address type' do
        expect(json_body[:name]).to eq(permission_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:permission_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /permissions/:id' do
    before do
      delete "/permissions/#{permission_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Permission.find_by(id: permission_id)).to be_nil
    end
  end
end
