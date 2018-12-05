require 'rails_helper'

RSpec.describe 'Employee API', type: :request do
  let!(:employees) { create_list(:employee, 4) }
  let(:employee) { employees.last }
  let(:employee_id) { employee.id }
  let!(:user){ create(:employee, admin:true) }
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

  describe 'GET /employees' do
    before do
      get '/employees', params: {}, headers: headers
    end
    it 'return 5 employees from database' do
      expect(json_body.count).to eq(5)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /employees/:id' do
    before do
      get "/employees/#{employee_id}", params: {}, headers: headers
    end
    it 'return address from database' do
      expect(json_body[:name]).to eq(employee[:name])
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /employees' do
    before do
      post '/employees', params: employee_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:employee_params) { attributes_for(:employee, {password: 12345678, password_confirmation: 12345678}) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created employee' do
        expect(json_body[:name]).to eq(employee_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:employee_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /employees/:id' do
    before do
      put "/employees/#{employee_id}", params: employee_params.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:employee_params) { { name: 'jorge' } }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated employee' do
        expect(json_body[:name]).to eq(employee_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:employee_params) { { name: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /employees/:id' do
    before do
      delete "/employees/#{employee_id}", params: { } , headers: headers
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Employee.find_by(id: employee_id).active).to eq(false)
    end
  end
end
