require 'rails_helper'

RSpec.describe 'City API', type: :request do
  before do 
    @api = create(:api)
    @cities = create_list(:city, 5)
    @city = @cities.first
    @city_id = @city.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /cities' do
    before do
      get "/cities#{@auth_data}", params: {}
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
      get "/cities/#{@city_id}#{@auth_data}", params: {}
    end
    it 'return city from database' do
      expect(json_body.size).to eq(Api::CitySerializer.new(@city).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /cities' do
    before do
      post "/cities#{@auth_data}", params: city_params 
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
      put "/cities/#{@city_id}#{@auth_data}", params: city_params 
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
      delete "/cities/#{@city_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(City.find_by(id: @city_id)).to be_nil
    end
  end
end
