require 'rails_helper'

RSpec.describe 'SubCategory API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:sub_categories) { create_list(:sub_category, 5) }
  let(:sub_category) { sub_categories.first }
  let(:sub_category_id) { sub_category.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /sub_categories' do
    before do
      get '/sub_categories', params: {}, headers: headers
    end
    it 'return 5 sub_categories from database' do
      expect(json_body[:data].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /sub_categories/:id' do
    before do
      get "/sub_categories/#{sub_category_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:data][:attributes][:name]).to eq(sub_category[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /sub_categories' do
    before do
      post '/sub_categories', params: { sub_category: sub_category_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:sub_category_params) { attributes_for(:sub_category) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created sub_category' do
        expect(json_body[:data][:attributes][:name]).to eq(sub_category_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:sub_category_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /sub_categories/:id' do
    before do
      put "/sub_categories/#{sub_category_id}", params: { sub_category: sub_category_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:sub_category_params) { { name: 'jorge' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated sub_category' do
        expect(json_body[:data][:attributes][:name]).to eq(sub_category_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:sub_category_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /sub_categories/:id' do
    before do
      delete "/sub_categories/#{sub_category_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(SubCategory.find_by(id: sub_category_id)).to be_nil
    end
  end
end
