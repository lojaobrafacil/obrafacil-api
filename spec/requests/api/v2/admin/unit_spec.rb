require 'rails_helper'

RSpec.describe 'Unit API', type: :request do
  let!(:user){ create(:employee) }
  let!(:units) { create_list(:unit, 5) }
  let(:unit) { units.first }
  let(:unit_id) { unit.id }
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

  describe 'GET /admin/units' do
    before do
      get '/admin/units', params: {}, headers: headers
    end
    it 'return 5 units from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/units/:id' do
    before do
      get "/admin/units/#{unit_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(unit[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /admin/units' do
    before do
      post '/admin/units', params: unit_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:unit_params) { attributes_for(:unit) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created unit' do
        expect(json_body[:name]).to eq(unit_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:unit_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /admin/units/:id' do
    before do
      put "/admin/units/#{unit_id}", params: unit_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:unit_params) { { name: unit.name } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated unit' do
        expect(json_body[:name]).to eq(unit_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:unit_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /admin/units/:id' do
    before do
      delete "/admin/units/#{unit_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Unit.find_by(id: unit_id)).to be_nil
    end
  end
end
