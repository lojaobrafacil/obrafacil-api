require 'rails_helper'

RSpec.describe 'EmailType API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:email_types) { create_list(:email_type, 5) }
  let(:email_type) { email_types.first }
  let(:email_type_id) { email_type.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /email_types' do
    before do
      get '/email_types', params: {}, headers: headers
    end
    it 'return 5 email types from database' do
      expect(json_body[:data].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /email_types/:id' do
    before do
      get "/email_types/#{email_type_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:data][:attributes][:name]).to eq(email_type[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /email_types' do
    before do
      post '/email_types', params: { email_type: email_type_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:email_type_params) { attributes_for(:email_type) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created email type' do
        expect(json_body[:data][:attributes][:name]).to eq(email_type_params[:name])
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

  describe 'PUT /email_types/:id' do
    before do
      put "/email_types/#{email_type_id}", params: { email_type: email_type_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:email_type_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated email type' do
        expect(json_body[:data][:attributes][:name]).to eq(email_type_params[:name])
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

  describe 'DELETE /email_types/:id' do
    before do
      delete "/email_types/#{email_type_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(EmailType.find_by(id: email_type_id)).to be_nil
    end
  end
end
