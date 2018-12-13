require 'rails_helper'

RSpec.describe 'BillingType API', type: :request do
  before do 
    @api = create(:api)
    @billing_types = create_list(:billing_type, 5)
    @billing_type = @billing_types.first
    @billing_type_id = @billing_type.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /billing_types' do
    before do
      get "/billing_types#{@auth_data}", params: {}
    end
    it 'return 5 billing types from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /billing_types/:id' do
    before do
      get "/billing_types/#{@billing_type_id}#{@auth_data}", params: {}
    end
    it 'return billing type from database' do
      expect(json_body.size).to eq(Api::BillingTypeSerializer.new(@billing_type).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /billing_types' do
    before do
      post "/billing_types#{@auth_data}", params: billing_type_params 
    end

    context 'when the request params are valid' do
      let(:billing_type_params) { attributes_for(:billing_type) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created billing type' do
        expect(json_body[:name]).to eq(billing_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:billing_type_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /billing_types/:id' do
    before do
      put "/billing_types/#{@billing_type_id}#{@auth_data}", params: billing_type_params 
    end

    context 'when the request params are valid' do
      let(:billing_type_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated billing type' do
        expect(json_body[:name]).to eq(billing_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:billing_type_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /billing_types/:id' do
    before do
      delete "/billing_types/#{@billing_type_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(BillingType.find_by(id: @billing_type_id)).to be_nil
    end
  end
end
