require 'rails_helper'

RSpec.describe 'SubCategory API', type: :request do
  before do 
    @api = create(:api)
    @sub_categories = create_list(:sub_category, 5)
    @sub_category = @sub_categories.first
    @sub_category_id = @sub_category.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /sub_categories' do
    before do
      get "/sub_categories#{@auth_data}", params: {}
    end
    it 'return 5 sub_categories from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /sub_categories/:id' do
    before do
      get "/sub_categories/#{@sub_category_id}#{@auth_data}", params: {}
    end
    it 'return sub_category from database' do
      expect(json_body.size).to eq(Api::SubCategorySerializer.new(@sub_category).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /sub_categories' do
    before do
      post "/sub_categories#{@auth_data}", params: sub_category_params 
    end

    context 'when the request params are valid' do
      let(:sub_category_params) { attributes_for(:sub_category) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created sub_category' do
        expect(json_body[:name]).to eq(sub_category_params[:name])
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
      put "/sub_categories/#{@sub_category_id}#{@auth_data}", params: sub_category_params 
    end

    context 'when the request params are valid' do
      let(:sub_category_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated sub_category' do
        expect(json_body[:name]).to eq(sub_category_params[:name])
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
      delete "/sub_categories/#{@sub_category_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(SubCategory.find_by(id: @sub_category_id)).to be_nil
    end
  end
end
