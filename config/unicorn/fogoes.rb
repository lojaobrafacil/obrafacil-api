root = "/var/api/emam/current"
working_directory root

pid "#{root}/tmp/pids/unicorn.pid"

stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

worker_processes 6
timeout 60
preload_app true

listen "/tmp/unicorn.emam.sock", backlog: 64
