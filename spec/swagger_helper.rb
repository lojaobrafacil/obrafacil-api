require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.to_s + '/public'

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:to_swagger' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'swagger.json' => {
      swagger: '2.0',
      info: {
        title: 'Hubco API',
        version: '200'
      },
      paths: {}
    }
  }

  def params_auth
    parameter name: :access_id, in: :query, type: :string, description: 'your-access-id'
    parameter name: :access_key, in: :query, type: :string, description: 'your-access-key'
  end

  def auth_api
    let(:api) { Api.find_or_create_by!(name: "Test", federal_registration: "12345678901") }
    let(:access_id) { api.access_id }
    let(:access_key) { api.access_key }
  end
end
