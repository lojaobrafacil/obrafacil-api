require 'rails_helper'

RSpec.describe 'PricePercentage API', type: :request do
  let!(:user){ create(:employee, admin:true) }
  let(:auth_data) { user.create_new_auth_token }
  let(:companies) {}
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v2',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /admin/price_percentages' do
    before do
      [1,2,3].each do |n|
        create(:price_percentage, kind: n)
      end
      get '/admin/price_percentages', params: {}, headers: headers
    end
    it 'return 5 price_percentages from database' do
      expect(json_body.count).to eq(3)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/price_percentages/:id' do
    PricePercentage.destroy_all
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    let(:company) { create(:company) }
    before do
      get "/admin/price_percentages/#{company.id}", params: {}, headers: headers
    end
    it 'return price percentages kind from database' do
      expect(json_body[:kind_1]).to eq(1)
      expect(json_body[:kind_2]).to eq(2)
      expect(json_body[:kind_3]).to eq(3)
      expect(json_body[:kind_4]).to eq(4)
      expect(json_body[:kind_5]).to eq(5)
      
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PUT /admin/price_percentages/:id' do
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    let(:price_percentage_params) { {price_percentages: [
        {kind: 1, margin: 0}, 
        {kind: 2, margin: 0}, 
        {kind: 3, margin: 0},
        {kind: 4, margin: 0},
        {kind: 5, margin: 0}
      ]}
    }
    let(:company) {create(:company)}

    before do
      put "/admin/price_percentages/#{company.id}", params: price_percentage_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:price_percentage_params) { {price_percentages: [
        {kind: 1, margin: Faker::Number.decimal(2)}, 
        {kind: 2, margin: Faker::Number.decimal(2)}, 
        {kind: 3, margin: Faker::Number.decimal(2)},
        {kind: 4, margin: Faker::Number.decimal(2)},
        {kind: 5, margin: Faker::Number.decimal(2)}
      ]}
    }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated price_percentage' do
        expect(json_body[:margin].to_s).to eq(price_percentage_params[:margin].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:price_percentage_params) { { price_percentages: [{}] } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end 

end
