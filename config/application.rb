require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module Emam
  class Application < Rails::Application
    config.load_defaults 5.1
    Dir[File.join(Rails.root, "lib", "**", "*.rb")].each { |l| require l }
    config.autoload_paths += %W(#{config.root}/app/uploaders/helpers)
    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
    config.active_job.queue_adapter = :sidekiq

    config.api_only = true
    config.i18n.default_locale = :'pt-BR'
    Faker::Config.locale = :"pt-BR"
  end
end
