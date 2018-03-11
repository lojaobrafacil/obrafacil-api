require 'rails_helper'

RSpec.describe 'Phone API', type: :request do
  let!(:user){ create(:user) }
  let!(:phones) { create_list(:phone, 2) }
  let(:phone) { phones.first }
  let(:phone_id) { phone.id }
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

  describe 'GET /phones' do
    before do
      get '/phones', params: {}, headers: headers
    end
    it 'return 2 phone types from database' do
      expect(json_body.count).to eq(2)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /phones/:id' do
    before do
      get "/phones/#{phone_id}", params: {}, headers: headers
    end
    it 'return phone from database' do
      expect(json_body[:phone]).to eq(phone[:phone])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

# phones will only be created in the associated controller
  # describe 'POST /phones' do
  #   before do
  #     post '/phones', params: { phone: phone_params }.to_json , headers: headers
  #   end
  #
  #   context 'when the request params are valid' do
  #     let(:phone_params) { attributes_for(:phone) }
  #
  #     it 'return status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #
  #     it 'returns the json data for the created phone type' do
  #       expect(json_body[:phone]).to eq(phone_params[:phone])
  #     end
  #   end
  #
  #   context 'when the request params are invalid' do
  #     let(:phone_params) { { phone: '' } }
  #
  #     it 'return status code 422' do
  #       expect(response).to have_http_status(422)
  #     end
  #
  #     it 'return the json data for the errors' do
  #       expect(json_body).to have_key(:errors)
  #     end
  #   end
  # end

  describe 'PUT /phones/:id' do
    before do
      put "/phones/#{phone_id}", params: { phone: phone_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:phone_params) { { phone: '11975226584' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated phone type' do
        expect(json_body[:phone]).to eq(phone_params[:phone])
      end
    end

    context 'when the request params are invalid' do
      let(:phone_params) { { phone: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /phones/:id' do
    before do
      delete "/phones/#{phone_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Phone.find_by(id: phone_id)).to be_nil
    end
  end
end
