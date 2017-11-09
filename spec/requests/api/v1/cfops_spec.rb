require 'rails_helper'

RSpec.describe 'Cfop API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:cfops) { create_list(:cfop, 5) }
  let(:cfop) { cfops.first }
  let(:cfop_id) { cfop.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /cfops' do
    before do
      get '/cfops', params: {}, headers: headers
    end
    it 'return 5 cfops from database' do
      expect(json_body[:cfops].count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /cfops/:id' do
    before do
      get "/cfops/#{cfop_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body.to_json).to eq(cfop.to_json)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /cfops' do
    before do
      post '/cfops', params: { cfop: cfop_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:cfop_params) { attributes_for(:cfop) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created cfop' do
        expect(json_body[:code].to_s).to eq(cfop_params[:code].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:cfop_params) { { code: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /cfops/:id' do
    before do
      put "/cfops/#{cfop_id}", params: { cfop: cfop_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:cfop_params) { { code: 15245 } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated cfop' do
        expect(json_body[:code]).to eq(cfop_params[:code])
      end
    end

    context 'when the request params are invalid' do
      let(:cfop_params) { { code: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /cfops/:id' do
    before do
      delete "/cfops/#{cfop_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Cfop.find_by(id: cfop_id)).to be_nil
    end
  end
end
