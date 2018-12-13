require 'rails_helper'

RSpec.describe 'Unit API', type: :request do
  before do 
    @api = create(:api)
    @units = create_list(:unit, 5)
    @unit = @units.first
    @unit_id = @unit.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /units' do
    before do
      get "/units#{@auth_data}", params: {}
    end
    it 'return 5 units from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /units/:id' do
    before do
      get "/units/#{@unit_id}#{@auth_data}", params: {}
    end
    it 'return unit from database' do
      expect(json_body.size).to eq(Api::UnitSerializer.new(@unit).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /units' do
    before do
      post "/units#{@auth_data}", params: unit_params 
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

  describe 'PUT /units/:id' do
    before do
      put "/units/#{@unit_id}#{@auth_data}", params: unit_params 
    end

    context 'when the request params are valid' do
      let(:unit_params) { { name: "Novo" } }

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

  describe 'DELETE /units/:id' do
    before do
      delete "/units/#{@unit_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Unit.find_by(id: @unit_id)).to be_nil
    end
  end
end
