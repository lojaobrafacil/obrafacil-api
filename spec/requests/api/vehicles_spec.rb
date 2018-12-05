require 'rails_helper'

RSpec.describe 'Vehicle API', type: :request do
  let!(:user){ create(:employee, admin:true) }
  let!(:vehicles) { create_list(:vehicle, 5) }
  let(:vehicle) { vehicles.first }
  let(:vehicle_id) { vehicle.id }
  let(:vehicle_model) { vehicle.model}
  let(:vehicle_brand) { vehicle.brand}
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

  describe 'GET /vehicles' do
    before do
      get '/vehicles', params: {}, headers: headers
    end
    it 'return 5 vehicles from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /vehicles/:id' do
    before do
      get "/vehicles/#{vehicle.id}", params: {}, headers: headers
    end
    it 'return vehicle from database' do
      expect(json_body[:brand]).to eq(vehicle[:brand])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /vehicles' do
    before do
      post '/vehicles', params: vehicle_params.to_json  , headers: headers
    end

    context 'when the request params are valid' do
      let(:vehicle_params) { attributes_for(:vehicle) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created vehicle' do
        expect(json_body[:brand]).to eq(vehicle_params[:brand])
      end
    end

    context 'when the request params are invalid' do
      let(:vehicle_params) { { brand: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /vehicles/:id' do
    before do 
      put "/vehicles/#{vehicle_id}", params: vehicle_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:vehicle_params) { { brand: vehicle.brand } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated vehicle' do
        expect(json_body[:brand]).to eq(vehicle_params[:brand])
      end
    end

    context 'when the request params are invalid' do
      let(:vehicle_params) { { brand: nil } }
      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /vehicles/:id' do
    before do
      delete "/vehicles/#{vehicle_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Vehicle.find_by(id: vehicle_id)).to be_nil
    end
  end
end
