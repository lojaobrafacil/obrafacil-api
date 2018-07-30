require 'rails_helper'

RSpec.describe 'Bank API', type: :request do
  let!(:auth){ create(:v2_admin_employee) }
  let!(:banks) { create_list(:v2_admin_bank, 5) }
  let(:bank) { banks.first }
  let(:bank_id) { bank.id }
  let(:auth_data) { auth.create_new_auth_token }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v2',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /banks' do
    before do
      get '/admin/banks', params: {}, headers: headers
    end
    it 'return 5 banks from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /banks/:id' do
    before do
      get '/admin/banks/#{bank_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:code]).to eq(bank.code)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /banks' do
    before do
      post '/admin/banks', params: { bank: bank_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:bank_params) { attributes_for(:bank) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created bank' do
        expect(json_body[:name]).to eq(bank_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:bank_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /banks/:id' do
    before do
      put '/admin/banks/#{bank_id}', params: { bank: bank_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:bank_params) { { name: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated bank' do
        expect(json_body[:name]).to eq(bank_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:bank_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /banks/:id' do
    before do
      delete '/admin/banks/#{bank_id}', params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Bank.find_by(id: bank_id)).to be_nil
    end
  end
end
