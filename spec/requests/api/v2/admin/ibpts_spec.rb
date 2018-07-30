require 'rails_helper'

RSpec.describe 'Ibpt API', type: :request do
  let!(:auth){ create(:employee) }
  let!(:ibpts) { create_list(:ibpt, 5) }
  let(:ibpt) { ibpts.first }
  let(:ibpt_id) { ibpt.id }
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

  describe 'GET /ibpts' do
    before do
      get '/admin/ibpts', params: {}, headers: headers
    end
    it 'return 5 ibpts from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /ibpts/:id' do
    before do
      get '/admin/ibpts/#{ibpt_id}', params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:code]).to eq(ibpt[:code])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /ibpts' do
    before do
      post '/admin/ibpts', params: { ibpt: ibpt_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:ibpt_params) { attributes_for(:ibpt) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created ibpt' do
        expect(json_body[:code].to_s).to eq(ibpt_params[:code].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:ibpt_params) { { code: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /ibpts/:id' do
    before do
      put '/admin/ibpts/#{ibpt_id}', params: { ibpt: ibpt_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:ibpt_params) { { code: 54458 } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated ibpt' do
        expect(json_body[:code].to_s).to eq(ibpt_params[:code].to_s)
      end
    end

    context 'when the request params are invalid' do
      let(:ibpt_params) { { code: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /ibpts/:id' do
    before do
      delete '/admin/ibpts/#{ibpt_id}', params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Ibpt.find_by(id: ibpt_id)).to be_nil
    end
  end
end
