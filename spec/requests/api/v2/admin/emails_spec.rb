require 'rails_helper'

RSpec.describe 'Email API', type: :request do
  let!(:user){ create(:employee) }
  let!(:emails) { create_list(:email, 2) }
  let(:email) { emails.first }
  let(:email_id) { email.id }
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

  describe 'GET /admin/emails' do
    before do
      get '/admin/emails', params: {}, headers: headers
    end
    it 'return 2 email types from database' do
      expect(json_body.count).to eq(2)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /admin/emails/:id' do
    before do
      get "/admin/emails/#{email_id}", params: {}, headers: headers
    end
    it 'return email from database' do
      expect(json_body[:email]).to eq(email.email)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

# emails will only be created in the associated controller
  # describe 'POST /admin/emails' do
  #   before do
  #     post '/admin/emails', params: { email: email_params }.to_json , headers: headers
  #   end
  #
  #   context 'when the request params are valid' do
  #     let(:email_params) { attributes_for(:email) }
  #
  #     it 'return status code 201' do
  #       expect(response).to have_http_status(201)
  #     end
  #
  #     it 'returns the json data for the created email type' do
  #       expect(json_body[:email]).to eq(email_params[:email])
  #     end
  #   end
  #
  #   context 'when the request params are invalid' do
  #     let(:email_params) { { email: '' } }
  #
  #     it 'return status code 422' do
  #       expect(response).to have_http_status(422)
  #     end
  #
  #     it 'return the json data for the errors' do
  #       expect(json_body).to have_key(:errors)
  #     end
  #   end
  # end

  describe 'PUT /admin/emails/:id' do
    before do
      put "/admin/emails/#{email_id}", params: email_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:email_params) { { email: 'Comercial' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated email type' do
        expect(json_body[:email]).to eq(email_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:email_params) { { email: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /admin/emails/:id' do
    before do
      delete "/admin/emails/#{email_id}", params: { }.to_json , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Email.find_by(id: email_id)).to be_nil
    end
  end
end
