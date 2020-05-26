server "161.35.114.13", user: "deploy", roles: %w{app web}
# server "hubcoapp.ceohfyrrbarw.us-east-1.rds.amazonaws.com", user: "master", roles: %w{db}
set :sidekiq_role, :app
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_env, "production"
set :rvm_ruby_version, "2.6.0"
set :branch, "fogoes"
