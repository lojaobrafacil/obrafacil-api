require 'rails_helper'

RSpec.describe 'Employee API', type: :request do
  before { host! 'api.emamapp.dev'}
  let!(:user){ create(:user) }
  let!(:employees) { create_list(:employee, 5) }
  let(:employee) { employees.first }
  let(:employee_id) { employee.id }
  let(:headers) do
    {
      'Accept'  => 'application/vnd.emam.v1',
      'Content-type' => Mime[:json].to_s,
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /employees' do
    before do
      get '/employees', params: {}, headers: headers
    end
    it 'return 5 employees from database' do
      expect(json_body[:employees].count).to eq(5)
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
      expect(json_body.to_json).to eq(employee.to_json)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end


  describe 'POST /employees' do
    before do
      post '/employees', params: { employee: employee_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:employee_params) { attributes_for(:employee) }

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
      put "/employees/#{employee_id}", params: { employee: employee_params }.to_json , headers: headers
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
      expect(Employee.find_by(id: employee_id)).to be_nil
    end
  end
end
