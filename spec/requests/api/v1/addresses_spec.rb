require 'rails_helper'

RSpec.describe 'Address API', type: :request do
  let!(:user){ create(:user) }
  let!(:addresses) { create_list(:address, 2) }
  let(:address) { addresses.first }
  let(:address_id) { address.id }
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

  describe 'GET /addresses' do
    before do
      get '/addresses', params: {}, headers: headers
    end
    it 'return 2 address types from database' do
      expect(json_body.count).to eq(2)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /addresses/:id' do
    before do
      get "/addresses/#{address_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:street]).to eq(address.street)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

# addresses will only be created in the associated controller
  # describe 'POST /addresses' do
  #   before do
  #     post '/addresses', params: { address: address_params }.to_json , headers: headers
  #   end
  #
  #   context 'when the request params are valid' do
  #     let(:address_params) { attributes_for(:address) }
  #
  #     it 'return status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #
  #     it 'returns the json data for the created address type' do
  #       expect(json_body[:street]).to eq(address_params[:street])
  #     end
  #   end
  #
  #   context 'when the request params are invalid' do
  #     let(:address_params) { { street: '' } }
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

  describe 'PUT /addresses/:id' do
    before do
      put "/addresses/#{address_id}", params: address_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:address_params) { { street: address.street } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated address type' do
        expect(json_body[:street]).to eq(address_params[:street])
      end
    end

    context 'when the request params are invalid' do
      let(:address_params) { { street: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /addresses/:id' do
    before do
      delete "/addresses/#{address_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Address.find_by(id: address_id)).to be_nil
    end
  end
end
