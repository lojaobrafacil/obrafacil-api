require 'rails_helper'

RSpec.describe 'Category API', type: :request do
  before do 
    @api = create(:api)
    @categories = create_list(:category, 5)
    @category = @categories.first
    @category_id = @category.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /categories' do
    before do
      get "/categories#{@auth_data}", params: {}
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
      get "/categories/#{@category_id}#{@auth_data}", params: {}
    end
    it 'return category from database' do
      expect(json_body.size).to eq(Api::CategorySerializer.new(@category).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /categories' do
    before do
      post "/categories#{@auth_data}", params: category_params 
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
      put "/categories/#{@category_id}#{@auth_data}", params: category_params 
    end

    context 'when the request params are valid' do
      let(:category_params) { { name: 'Comercial' } }

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
      delete "/categories/#{@category_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Category.find_by(id: @category_id)).to be_nil
    end
  end
end
