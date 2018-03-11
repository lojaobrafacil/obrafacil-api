require 'rails_helper'

RSpec.describe 'Category API', type: :request do
  let!(:user){ create(:user) }
  let!(:categories) { create_list(:category, 5) }
  let(:category) { categories.first }
  let(:category_id) { category.id }
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

  describe 'GET /categories' do
    before do
      get '/categories', params: {}, headers: headers
    end
    it 'return 5 categories from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /categories/:id' do
    before do
      get "/categories/#{category_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(category.name)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /categories' do
    before do
      post '/categories', params: { category: category_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:category_params) { attributes_for(:category) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created category' do
        expect(json_body[:name]).to eq(category_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:category_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /categories/:id' do
    before do
      put "/categories/#{category_id}", params: { category: category_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:category_params) { { name: 'jorge' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated category' do
        expect(json_body[:name]).to eq(category_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:category_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /categories/:id' do
    before do
      delete "/categories/#{category_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Category.find_by(id: category_id)).to be_nil
    end
  end
end
