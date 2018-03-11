require 'rails_helper'

RSpec.describe 'PricePercentage API', type: :request do
  let!(:user){ create(:user) }
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

  describe 'GET /price_percentages' do
    before do
      [1,2,3].each do |n|
        create(:price_percentage, kind: n)
      end
      get '/price_percentages', params: {}, headers: headers
    end
    it 'return 5 price_percentages from database' do
      expect(json_body.count).to eq(3)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /price_percentages/:id' do
    PricePercentage.destroy_all
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    before do
      get "/price_percentages/#{price_percentage_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:margin]).to eq(price_percentage[:margin])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /price_percentages' do
    PricePercentage.destroy_all
    before do
      post '/price_percentages', params: { price_percentage: price_percentage_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:price_percentage_params) { attributes_for(:price_percentage) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created price_percentage' do
        expect(json_body[:margin].to_s).to eq(price_percentage_params[:margin].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:price_percentage_params) { { margin: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /price_percentages/:id' do
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    before do
      put "/price_percentages/#{price_percentage_id}", params: { price_percentage: price_percentage_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:price_percentage_params) { { margin: 0.2 } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated price_percentage' do
        expect(json_body[:margin].to_s).to eq(price_percentage_params[:margin].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:price_percentage_params) { { margin: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /price_percentages/:id' do
    PricePercentage.destroy_all
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    before do
      delete "/price_percentages/#{price_percentage_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(PricePercentage.find_by(id: price_percentage_id)).to be_nil
    end
  end
end
