require 'rails_helper'

RSpec.describe 'Company API', type: :request do
  before do 
    @api = create(:api)
    @companies = create_list(:company, 5)
    @company = @companies.first
    @company_id = @company.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /companies' do
    before do
      get "/companies#{@auth_data}", params: {}
    end
    it 'return 5 companys from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /companies/:id' do
    before do
      get "/companies/#{@company_id}#{@auth_data}", params: {}
    end
    it 'return company from database' do
      expect(json_body.size).to eq(Api::CompanySerializer.new(@company).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /companies' do
    before do
      post "/companies#{@auth_data}", params: company_params 
    end

    context 'when the request params are valid' do
      let(:company_params) { attributes_for(:company) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created company' do
        expect(json_body[:name]).to eq(company_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:company_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /companies/:id' do
    before do
      put "/companies/#{@company_id}#{@auth_data}", params: company_params 
    end

    context 'when the request params are valid' do
      let(:company_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated company' do
        expect(json_body[:name]).to eq(company_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:company_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /companies/:id' do
    before do
      delete "/companies/#{@company_id}#{@auth_data}", params: { }.to_json 
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Company.find_by(id: @company_id)).to be_nil
    end
  end
end
