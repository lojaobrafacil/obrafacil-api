require 'rails_helper'

RSpec.describe 'Company API', type: :request do
  let!(:user){ create(:user) }
  let!(:companies) { create_list(:company, 5) }
  let(:company) { companies.first }
  let(:company_id) { company.id }
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

  describe 'GET /companies' do
    before do
      get '/companies', params: {}, headers: headers
    end
    it 'return 5 companies from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /companies/:id' do
    before do
      get "/companies/#{company_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(company.name)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /companies' do
    before do
      post '/companies', params: { company: company_params }.to_json , headers: headers
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
      put "/companies/#{company_id}", params: { company: company_params }.to_json , headers: headers
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
      delete "/companies/#{company_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Company.find_by(id: company_id)).to be_nil
    end
  end
end
