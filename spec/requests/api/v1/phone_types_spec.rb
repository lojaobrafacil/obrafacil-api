require 'rails_helper'

RSpec.describe 'PhoneType API', type: :request do
  before { host! 'api.hubcoapp.dev'}
  let!(:user){ create(:user) }
  let!(:phone_types) { create_list(:phone_type, 5) }
  let(:phone_type) { phone_types.first }
  let(:phone_type_id) { phone_type.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /phone_types' do
    before do
      get '/phone_types', params: {}, headers: headers
    end
    it 'return 5 phone types from database' do
      expect(json_body[:phone_types].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /phone_types/:id' do
    before do
      get "/phone_types/#{phone_type_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body.to_json).to eq(phone_type.to_json)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /phone_types' do
    before do
      post '/phone_types', params: { phone_type: phone_type_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:phone_type_params) { attributes_for(:phone_type) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created phone type' do
        expect(json_body[:name]).to eq(phone_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:phone_type_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /phone_types/:id' do
    before do
      put "/phone_types/#{phone_type_id}", params: { phone_type: phone_type_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:phone_type_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated phone type' do
        expect(json_body[:name]).to eq(phone_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:phone_type_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /phone_types/:id' do
    before do
      delete "/phone_types/#{phone_type_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(PhoneType.find_by(id: phone_type_id)).to be_nil
    end
  end
end
