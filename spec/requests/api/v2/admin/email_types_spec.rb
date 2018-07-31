require 'rails_helper'

RSpec.describe 'EmailType API', type: :request do
  let!(:user){ create(:employee) }
  let!(:email_types) { create_list(:email_type, 5) }
  let(:email_type) { email_types.first }
  let(:email_type_id) { email_type.id }
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

  describe 'GET /admin/email_types' do
    before do
      get '/admin/email_types', params: {}, headers: headers
    end
    it 'return 5 email types from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/email_types/:id' do
    before do
      get "/admin/email_types/#{email_type_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(email_type[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /admin/email_types' do
    before do
      post '/admin/email_types', params: email_type_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:email_type_params) { attributes_for(:email_type) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created email type' do
        expect(json_body[:name]).to eq(email_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:email_type_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /admin/email_types/:id' do
    before do
      put "/admin/email_types/#{email_type_id}", params: email_type_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:email_type_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated email type' do
        expect(json_body[:name]).to eq(email_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:email_type_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /admin/email_types/:id' do
    before do
      delete "/admin/email_types/#{email_type_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(EmailType.find_by(id: email_type_id)).to be_nil
    end
  end
end
