require 'rails_helper'

RSpec.describe 'PhoneType API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:phone_types) { create_list(:phone_type, 5) }
  let(:phone_type) { phone_types.first }
  let(:phone_type_id) { phone_type.id }
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

  describe 'GET /phone_types' do
    before do
      get '/admin/phone_types', params: {}, headers: headers
    end
    it 'return 5 phone types from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /phone_types/:id' do
    before do
      get '/admin/phone_types/#{phone_type_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(phone_type[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /phone_types' do
    before do
      post '/admin/phone_types', params: { phone_type: phone_type_params }.to_json , headers: headers
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
      put '/admin/phone_types/#{phone_type_id}', params: { phone_type: phone_type_params }.to_json , headers: headers
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
      delete '/admin/phone_types/#{phone_type_id}', params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(PhoneType.find_by(id: phone_type_id)).to be_nil
    end
  end
end
