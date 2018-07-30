require 'rails_helper'

RSpec.describe 'Region API', type: :request do
  let!(:auth){ create(:v2_admin_employee) }
  let!(:regions) { create_list(:v2_admin_region, 2) }
  let(:region) { regions.first }
  let(:region_id) { region.id }
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

  describe 'GET /regions' do
    before do
      get '/admin/regions', params: {}, headers: headers
    end
    it 'return 5 email types from database' do
      expect(json_body.count).to eq(2)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /regions/:id' do
    before do
      get '/admin/regions/#{region_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(region[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /regions' do
    before do
      post '/admin/regions', params: { region: region_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:region_params) { attributes_for(:region) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created email type' do
        expect(json_body[:name]).to eq(region_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:region_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /regions/:id' do
    before do
      put '/admin/regions/#{region_id}', params: { region: region_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:region_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated email type' do
        expect(json_body[:name]).to eq(region_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:region_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /regions/:id' do
    before do
      delete '/admin/regions/#{region_id}', params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Region.find_by(id: region_id)).to be_nil
    end
  end
end
