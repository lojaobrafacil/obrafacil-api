source "https://rubygems.org"
ruby "2.6.0"
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
gem "rails", "~> 5.2.2"
gem "pg", "~> 1.1.4"
gem "puma", "~> 4.0.0"
gem "redis", "~> 3.0"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "rack-cors"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 3.6"
  gem "rswag-specs"
  gem "simplecov", :require => false
end

group :production do
  gem "unicorn"
end

group :test do
  gem "database_cleaner"
  gem "shoulda-matchers", "4.0.0.rc1"
  gem "rails-controller-testing"
  gem "factory_bot_rails"
end
gem "faker"

group :development, :staging do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"
  gem "capistrano", "= 3.11.0"
  gem "capistrano-bundler", "~> 1.4"
  gem "capistrano-rails", "~> 1.4"
  gem "capistrano-rvm"
  gem "capistrano3-unicorn"
  gem "capistrano-rails-collection"
  gem "capistrano-sidekiq"
  gem "better_errors"
  gem "awesome_print"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "devise"
gem "active_model_serializers"
gem "omniauth"
gem "devise_token_auth"
gem "rails-i18n", "~> 5.0.0"
gem "kaminari"
gem "api-pagination"
gem "carrierwave"
gem "pundit"
gem "carrierwave-aws"
gem "mini_magick"
gem "dotenv-rails"
gem "rswag-api"
gem "rswag-ui"
gem "write_xlsx"
gem "pusher"
gem "prawn"
gem "prawn-rails"
gem "aws-sdk"
gem "crack"
gem "rubyzip"
gem "rqrcode"
