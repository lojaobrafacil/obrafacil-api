require 'rails_helper'

RSpec.describe 'Supplier API', type: :request do
  let!(:user){ create(:employee, admin:true) }
  let!(:suppliers) { create_list(:supplier, 5) }
  let(:supplier) { suppliers.first }
  let(:supplier_id) { supplier.id }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v2',
      'Content-type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /suppliers' do
    before do
      get '/suppliers', params: {}, headers: headers
    end
    it 'return 5 suppliers from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /suppliers/:id' do
    before do
      get "/suppliers/#{supplier_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(supplier[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /suppliers' do
    before do
      post '/suppliers', params: supplier_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:supplier_params) { attributes_for(:supplier) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created supplier' do
        expect(json_body[:name]).to eq(supplier_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:supplier_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /suppliers/:id' do
    before do
      put "/suppliers/#{supplier_id}", params: supplier_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:supplier_params) { { name: supplier.name } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated supplier' do
        expect(json_body[:name]).to eq(supplier_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:supplier_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /suppliers/:id' do
    before do
      delete "/suppliers/#{supplier_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Supplier.find_by(id: supplier_id)).to be_nil
    end
  end
end
