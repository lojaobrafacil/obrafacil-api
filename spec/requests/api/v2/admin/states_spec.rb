require 'rails_helper'

RSpec.describe 'State API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:states) { create_list(:state, 2) }
  let(:state) { states.first }
  let(:state_id) { state.id }
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

  describe 'GET /states' do
    before do
      get '/admin/states', params: {}, headers: headers
    end
    it 'return 5 email types from database' do
      expect(json_body.count).to eq(2)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /states/:id' do
    before do
      get '/admin/states/#{state_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(state[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /states' do
    before do
      post '/admin/states', params: { state: state_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:state_params) { attributes_for(:state) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created email type' do
        expect(json_body[:name]).to eq(state_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:state_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /states/:id' do
    before do
      put '/admin/states/#{state_id}', params: { state: state_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:state_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated email type' do
        expect(json_body[:name]).to eq(state_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:state_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /states/:id' do
    before do
      delete '/admin/states/#{state_id}', params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(State.find_by(id: state_id)).to be_nil
    end
  end
end
