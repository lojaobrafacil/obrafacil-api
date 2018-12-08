require 'swagger_helper'

describe 'Products API' do

  path '/products' do
    get 'All a products' do
      tags 'Products'
      produces 'application/json'
      params_auth
      parameter name: :page, in: :query, type: :string, description: 'page number', required: false
      parameter name: :"per-page", in: :query, type: :string, description: 'itens per page', required: false

      response 200, 'product found' do
        auth_api
        schema type: :array,
          items: { type: :object, properties: {
            id: { type: :integer },
            name: { type: :string },
            description: { type: :string },
            active: { type: :boolean }
          }
        }
        run_test!
      end
    end
  end

  path '/products/{id}' do
    get 'Retrieves a product' do
      tags 'Products'
      produces 'application/json'
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 200, 'product found' do
        auth_api
        schema type: :object,
          properties: {
            id: { type: :string, example: 1 },
            code: { type: :string, example: 111, description: "Codigo interno da fogoes shop" },
            name: { type: :string, example: Faker::Commerce.product_name },
            description: { type: :string, example: Faker::Commerce.material },
            ncm: { type: :string, example: Faker::Number.decimal(2) },
            icms: { type: :string, example: Faker::Number.decimal(2) },
            ipi: { type: :string, example: Faker::Number.decimal(2) },
            cest: { type: :string, example: Faker::Number.decimal(2) },
            bar_code: { type: :string, example: "7894916512510" },
            reduction: { type: :string, example: Faker::Number.decimal(2) },
            weight: { type: :string, example: Faker::Number.decimal(2) },
            height: { type: :string, example: Faker::Number.decimal(2) },
            width: { type: :string, example: Faker::Number.decimal(2) },
            length: { type: :string, example: Faker::Number.decimal(2) },
            kind: { type: :string, example: "third_party", description: "pode ser own, third_party ou not_marketed"},
            active: { type: :string, example: true },
            unit_id: { type: :string, example: 11 },
            sku: { type: :string, example: "123456" },
            sku_xml: { type: :string, example: "123456" },
            sub_category_id: { type: :string, example: 1 },
            supplier_id: { type: :string, example: 1 },
            category_id: { type: :string, example: 1},
            company_products: { type: :array, items: { type: :object, 
              properties: {
                  id: { type: :string },
                  stock: { type: :string, example: 0.0 },
                  stock_min: { type: :string, example: 0.0 },
                  stock_max: { type: :string, example: 0.0 },
                  cost: { type: :string },
                  discount: { type: :string },
                  st: { type: :string },
                  margin: { type: :string }
                }
              }
            }
          }

        let(:id) { 1 }
        run_test!
      end

      response 404, 'product not found' do
        auth_api
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/products' do
    post 'Creates a product' do
      tags 'Products'
      consumes 'application/json'
      params_auth

      parameter name: :product, in: :body, schema: {
        type: :object,
          properties: {
            code: { type: :string, example: 111, description: "Codigo interno da fogoes shop"},
            name: { type: :string, example: Faker::Commerce.product_name },
            description: { type: :string, example: Faker::Commerce.material },
            ncm: { type: :string, example: Faker::Number.decimal(2) },
            icms: { type: :string, example: Faker::Number.decimal(2) },
            ipi: { type: :string, example: Faker::Number.decimal(2) },
            cest: { type: :string, example: Faker::Number.decimal(2) },
            bar_code: { type: :string, example: "7894916512510" },
            reduction: { type: :string, example: Faker::Number.decimal(2) },
            weight: { type: :string, example: Faker::Number.decimal(2) },
            height: { type: :string, example: Faker::Number.decimal(2) },
            width: { type: :string, example: Faker::Number.decimal(2) },
            length: { type: :string, example: Faker::Number.decimal(2) },
            kind: { type: :string, example: "third_party", description: "pode ser own, third_party ou not_marketed"},
            active: { type: :string, example: true },
            unit_id: { type: :string, example: 11 },
            sku: { type: :string, example: "123456" },
            sku_xml: { type: :string, example: "123456" },
            sub_category_id: { type: :string, example: 1 },
            supplier_id: { type: :string, example: 1 },
            category_id: { type: :string, example: 1}
          },
          required: [ 'name', 'kind' ]
        }

      response 201, 'product created' do
        auth_api
        let(:product) { FactoryBot.attributes_for(:product) }
        run_test!
      end

      response 422, 'invalid request' do
        auth_api
        let(:product) { { name: 'foo' } }
        run_test!
      end
    end
  end

  path '/products/{id}' do
    put 'Updates a product' do
      tags 'Products'
      consumes 'application/json'
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      parameter name: :product, in: :body, schema: {
        type: :object,
          properties: {
            id: { type: :integer },
            code: { type: :integer, example: 111, description: "Codigo interno da fogoes shop" },
            name: { type: :string, example: Faker::Commerce.product_name },
            description: { type: :string, example: Faker::Commerce.material },
            ncm: { type: :float, example: Faker::Number.decimal(2) },
            icms: { type: :float, example: Faker::Number.decimal(2) },
            ipi: { type: :float, example: Faker::Number.decimal(2) },
            cest: { type: :float, example: Faker::Number.decimal(2) },
            color: { type: :string, example: Faker::Color.hex_color },
            bar_code: { type: :string, example: "7894916512510" },
            reduction: { type: :string, example: Faker::Number.decimal(2) },
            weight: { type: :float, example: Faker::Number.decimal(2) },
            height: { type: :float, example: Faker::Number.decimal(2) },
            width: { type: :float, example: Faker::Number.decimal(2) },
            length: { type: :float, example: Faker::Number.decimal(2) },
            kind: { type: :string, example: "third_party", description: "pode ser own, third_party ou not_marketed"},
            active: { type: :string, example: true },
            unit_id: { type: :integer, example: 11 },
            sku: { type: :string, example: "123456" },
            sku_xml: { type: :string, example: "123456" },
            sub_category_id: { type: :integer, example: 1 },
            supplier_id: { type: :integer, example: 1 },
            category_id: { type: :integer, example: 1},
            company_products: { type: :array, items: { type: :object, 
              properties: {
                  id: { type: :integer },
                  stock: { type: :integer, example: 0.0 },
                  stock_min: { type: :integer, example: 0.0 },
                  stock_max: { type: :integer, example: 0.0 },
                  cost: { type: :float },
                  discount: { type: :float },
                  st: { type: :string },
                  margin: { type: :string }
                }
              }, required: [ 'id' ]
            }
          },
          required: [ 'name', 'kind' ]
        }

      response 200, 'product updated' do
        auth_api
        let(:id) { FactoryBot.create(:product).id }
        run_test!
      end

      response 422, 'invalid request' do
        auth_api
        let(:id) { nil }
        run_test!
      end
    end
  end

  path '/products/{id}' do
    delete 'Destroy a product' do
      tags 'Products'
      consumes 'application/json'
      params_auth
      parameter name: :id, :in => :path, :type => :string, required: true

      response 204, 'product destroyed' do
        auth_api
        let(:id) { FactoryBot.create(:product).id }
        run_test!
      end

      response 422, 'invalid request' do
        auth_api
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end