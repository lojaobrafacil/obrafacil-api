require 'rails_helper'

RSpec.describe 'PricePercentage API', type: :request do
  before do 
    @api = create(:api)
    @price_percentages = create_list(:price_percentage, 5)
    @price_percentage = @price_percentages.first
    @company_id = @price_percentage.company_id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /price_percentages' do
    before do
      get "/price_percentages#{@auth_data}", params: {}
    end
    it 'return 5 phone types from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /price_percentages/:id' do
    before do
      get "/price_percentages/#{@company_id}#{@auth_data}", params: {}
    end
    it 'return phone type from database' do
      expect(json_body.size).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /price_percentages/:id' do
    before do
      put "/price_percentages/#{@company_id}#{@auth_data}", params: price_percentage_params 
    end

    context 'when the request params are valid' do
      let(:price_percentage_params) { { price_percentages: { margin: 12.2, kind: @price_percentage.kind } } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated phone type' do
        expect(json_body[:margin]).to eq(price_percentage_params[:margin])
      end
    end

    context 'when the request params are invalid' do
      let(:price_percentage_params) { { price_percentages: { margin: "oi", kind: 1 } } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
