# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "emam"
set :repo_url, "git@bitbucket.org:arthurjm95/emam.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/api/emam"

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

set :branch, "master"
set :log_level, :debug

after 'deploy:finished', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:stop'
    invoke 'unicorn:start'
  end
end

set_default(:redis_pid, "/var/run/redis/redis-server.pid")
set_default(:redis_port, 6379)


namespace :redis do
  desc "Install the latest release of Redis"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install redis-server"
  end
  after "deploy:install", "redis:install"

  # Just to use if you need to do more than the default configuration, mind to change the monit script details as well
  # desc "Setup Redis"
  # task :setup do
  #   run "#{sudo} cp /etc/redis/redis.conf /etc/redis/redis.conf.default"
  #   template "redis.conf.erb", "/tmp/redis.conf"
  #   run "#{sudo} mv /tmp/redis.conf /etc/redis/redis.conf"
  #   restart
  # end
  # after "deploy:setup", "redis:setup"

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command, roles: :web do
      run "#{sudo} service redis-server #{command}"
    end
  end
end
