require 'rails_helper'

RSpec.describe 'Partner API', type: :request do
  let!(:user){ create(:user) }
  let!(:partners) { create_list(:partner, 5) }
  let(:partner) { partners.first }
  let(:partner_id) { partner.id }
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

  describe 'GET /partners' do
    before do
      get '/partners', params: {}, headers: headers
    end
    it 'return 5 partners from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /partners/:id' do
    before do
      get "/partners/#{partner.id}", params: {}, headers: headers
    end
    it 'return partner from database' do
      expect(json_body[:name]).to eq(partner[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /partners' do
    before do
      post '/partners', params: partner_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:partner_params) { attributes_for(:partner) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created partner' do
        expect(json_body[:name]).to eq(partner_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:partner_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /partners/:id' do
    before do
      put "/partners/#{partner_id}", params: partner_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:partner_params) { { name: partner.name } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated partner' do
        expect(json_body[:name]).to eq(partner_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:partner_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /partners/:id' do
    before do
      delete "/partners/#{partner_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Partner.find_by(id: partner_id)).to be_nil
    end
  end
end
