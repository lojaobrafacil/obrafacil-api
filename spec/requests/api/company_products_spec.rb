# require 'rails_helper'

# RSpec.describe 'Company Product API', type: :request do
#   let!(:api){ create(:api) }
#   let!(:company_products) { create_list(:company_product, 5) }
#   let(:company_product) { company_products.first }
#   let(:company_product_id) { company_product.id }
#   let(:auth_data) { user.create_new_auth_token }
#   let(:auth_params) { "?access_id=#{api.access_id}&access_key=#{api.access_key}" }
#   end

#   describe "GET /company_products#{auth_params}" do
#     before do
#       get '/company_products', params: {}, headers: headers
#     end
#     it 'return 5 company_products from database' do
#       expect(json_body.count).to eq(5)
#     end

#     it 'return status 200' do
#       expect(response).to have_http_status(200)
#     end
#   end

#   describe "GET /company_products/:id#{auth_params}" do
#     before do
#       get "/company_products/#{company_product_id}", params: {}, headers: headers
#     end
#     it 'return address from database' do
#       expect(json_body[:name]).to eq(company_product[:name])
#     end

#     it 'return status 200' do
#       expect(response).to have_http_status(200)
#     end
#   end


#   describe "POST /company_products#{auth_params}" do
#     before do
#       post '/company_products', params: company_product_params.to_json , headers: headers
#     end

#     context 'when the request params are valid' do
#       let(:company_product_params) { attributes_for(:company_product) }

#       it 'return status code 201' do
#         expect(response).to have_http_status(201)
#       end

#       it 'returns the json data for the created company_product' do
#         expect(json_body[:name]).to eq(company_product_params[:name])
#       end
#     end

#     context 'when the request params are invalid' do
#       let(:company_product_params) { { name: '' } }

#       it 'return status code 422' do
#         expect(response).to have_http_status(422)
#       end

#       it 'return the json data for the errors' do
#         expect(json_body).to have_key(:errors)
#       end
#     end
#   end

#   describe "PUT /company_products/:id#{auth_params}" do
#     before do
#       put "/company_products/#{company_product_id}", params:  company_product_params.to_json , headers: headers
#     end

#     context 'when the request params are valid' do
#       let(:company_product_params) { { name: company_product.name } }

#       it 'return status code 200' do
#         expect(response).to have_http_status(200)
#       end

#       it 'return the json data for the updated company_product' do
#         expect(json_body[:name]).to eq(company_product_params[:name])
#       end
#     end

#     context 'when the request params are invalid' do
#       let(:company_product_params) { { name: nil } }

#       it 'return status code 422' do
#         expect(response).to have_http_status(422)
#       end

#       it 'return the json data for the errors' do
#         expect(json_body).to have_key(:errors)
#       end
#     end
#   end

#   describe "DELETE /company_products/:id#{auth_params}" do
#     before do
#       delete "/company_products/#{company_product_id}", params: { } , headers: headers
#     end

#     it 'return status code 204' do
#       expect(response).to have_http_status(204)
#     end

#     it 'removes the user from database' do
#       expect(Product.find_by(id: company_product_id)).to be_nil
#     end
#   end
# end
