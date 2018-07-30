require 'rails_helper'

RSpec.describe 'PricePercentage API', type: :request do
  let!(:user){ create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:companies) {}
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
    let(:company) { create(:company) }
    before do
      get "/price_percentages/#{company.id}", params: {}, headers: headers
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

  # describe 'POST /price_percentages' do
  #   PricePercentage.destroy_all
  #   before do
  #     post "/price_percentages/#{companyA.id}", params: price_percentage_params.to_json , headers: headers
  #   end
    
  #   context 'when the request params are valid' do
  #     let(:companyA) { create(:company) }
  #     let(:price_percentage_params) { attributes_for(:price_percentage) }

  #     it 'return status code 201' do
  #       expect(response).to have_http_status(201)
  #     end

  #     it 'returns the json data for the created price_percentage' do
  #       expect(json_body[:margin].to_s).to eq(price_percentage_params[:margin].to_s)
  #     end
  #   end

  #   context 'when the request params are invalid' do
  #     let(:price_percentage_params) { { margin: '' } }

  #     it 'return status code 422' do
  #       expect(response).to have_http_status(422)
  #     end

  #     it 'return the json data for the errors' do
  #       expect(json_body).to have_key(:errors)
  #     end
  #   end
  # end

  describe 'PUT /price_percentages/:id' do
    let(:price_percentage) { create(:price_percentage) }
    let(:price_percentage_id) { price_percentage.id }
    let(:price_percentage_params) {{ kind_1: 1, kind_2: 2, kind_3: 3, kind_4: 4, kind_5: 5, 
      margin_1: 0, margin_2: 0, margin_3: 0, margin_4: 0, margin_5: 0,}}
    let(:company) {create(:company)}

    before do
      put "/price_percentages/#{company.id}", params: (price_percentage_params).to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:price_percentage_params) { { margin_1: 0.2 } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated price_percentage' do
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

end
