Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.seconds.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.default_options = {from: '"Loja Obra Fácil" <naoresponda@lojaobrafacil.com.br>'}
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: "mail.lojaobrafacil.com.br",
    port: 587,
    domain: "lojaobrafacil.com.br",
    user_name: "naoresponda@lojaobrafacil.com.br",
    password: "JKGrf!lxO5LYTn",
    authentication: "plain",
    enable_starttls_auto: false,
  }
end
