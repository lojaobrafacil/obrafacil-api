# https://relishapp.com/rspec/rspec-rails/docs
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'database_cleaner'
require 'simplecov'
require 'sidekiq/testing'
require 'pundit/rspec'
require 'shoulda/matchers'
include ActiveModel::Serialization

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  config.pattern = "./spec/**/*_spec.rb"
  SimpleCov.start 'rails'
  config.before(:all, type: :request) do
    host! 'api.emamapp.test'
  end
  Sidekiq::Testing.fake!
  
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.include RequestSpecHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!
end
