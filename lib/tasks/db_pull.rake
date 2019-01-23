namespace :db do
  desc "Pull production db to development"
  task :pull => [:dump, :restore]

  task :dump do
    dumpfile = "#{Rails.root}/tmp/latest.dump"
    puts "PG_DUMP on production database..."
    production = Rails.application.config.database_configuration["production"]
    system "ssh root@165.227.180.52 'PGPASSWORD=root pg_dump -U postgres emam_production -h 165.227.180.52 -F t' > #{dumpfile}"
    puts "Done!"
  end

  task :restore do
    dev = Rails.application.config.database_configuration["development"]
    dumpfile = "#{Rails.root}/tmp/latest.dump"
    puts "PG_RESTORE on development database..."
    system "pg_restore --verbose --clean --no-acl --no-owner -h 127.0.0.1 -U postgres -d emam_development #{dumpfile}"
    puts "Done!"
  end
end
