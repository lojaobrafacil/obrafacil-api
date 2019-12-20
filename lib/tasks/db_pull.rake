namespace :db do
  desc "Pull production db to development"
  task :pull => [:dump, :restore]

  task :dump do
    dumpfile = "#{Rails.root}/tmp/latest.dump"
    puts "PG_DUMP on production database..."
    production = Rails.application.config.database_configuration["production"]
    system "pg_dump -C -h hubcoapp.ceohfyrrbarw.us-east-1.rds.amazonaws.com -U master emam_production -F t > #{dumpfile}"
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
