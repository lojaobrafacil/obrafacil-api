require 'rails_helper'

RSpec.describe 'Cashier API', type: :request do
  before do 
    @api = create(:api)
    @cashiers = create_list(:cashier, 5)
    @cashier = @cashiers.first
    @cashier_id = @cashier.id
    @auth_data = "?access_id=#{@api.access_id}&access_key=#{@api.access_key}"
  end

  describe 'GET /cashiers' do
    before do
      get "/cashiers#{@auth_data}", params: {}
    end
    it 'return 5 cashiers from database' do
      expect(json_body.count).to eq(5)
    end
    
    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end
  
  describe 'GET /cashiers/:id' do
    before do
      get "/cashiers/#{@cashier_id}#{@auth_data}", params: {}
    end
    it 'return cashier from database' do
      expect(json_body.size).to eq(Api::CashierSerializer.new(@cashier).as_json.size)
    end

    it 'return status 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /cashiers' do
    before do
      post "/cashiers#{@auth_data}", params: cashier_params 
    end

    context 'when the request params are valid' do
      let(:cashier_params) { attributes_for(:cashier) }

      it 'return status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns the json data for the created cashier' do
        expect(json_body[:name]).to eq(cashier_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:cashier_params) { { name: '' } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'PUT /cashiers/:id' do
    before do
      put "/cashiers/#{@cashier_id}#{@auth_data}", params: cashier_params 
    end

    context 'when the request params are valid' do
      let(:cashier_params) { attributes_for(:cashier) }

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'return the json data for the updated cashier' do
        expect(json_body[:start_date].to_date).to eq(cashier_params[:start_date].to_date)
      end
    end

    context 'when the request params are invalid' do
      let(:cashier_params) { { start_date: nil } }

      it 'return status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'return the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /cashiers/:id' do
    before do
      delete "/cashiers/#{@cashier_id}#{@auth_data}", params: { }
    end

    it 'return status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'removes the user from database' do
      expect(Cashier.find_by(id: @cashier_id)).to be_nil
    end
  end
end
