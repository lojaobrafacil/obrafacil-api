require 'rails_helper'

RSpec.describe 'City API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:cities) { create_list(:city, 5) }
  let(:city) { cities.first }
  let(:city_id) { city.id }
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

  describe 'GET /cities' do
    before do
      get '/admin/cities', params: {}, headers: headers
    end
    it 'return 5 cities from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /cities/:id' do
    before do
      get '/admin/cities/#{city_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(city.name)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /cities' do
    before do
      post '/admin/cities', params: { city: city_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:city_params) { attributes_for(:city) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created city' do
        expect(json_body[:name]).to eq(city_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:city_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /cities/:id' do
    before do
      put '/admin/cities/#{city_id}', params: { city: city_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:city_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated city' do
        expect(json_body[:name]).to eq(city_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:city_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /cities/:id' do
    before do
      delete '/admin/cities/#{city_id}', params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(City.find_by(id: city_id)).to be_nil
    end
  end
end
