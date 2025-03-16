namespace :heroku do
  desc "Pull Heroku database to local"
  task pull: :environment do
    app_name = "secret-aid"
    local_db = "my_app_development"  # Change this to match your local database name
    local_user = "your_local_postgres_user" # Change this if needed

    # Fetch Heroku DATABASE_URL
    database_url = `heroku config:get DATABASE_URL --app #{app_name}`.strip

    if database_url.empty?
      puts "Could not retrieve Heroku DATABASE_URL. Make sure you are logged in and the app name is correct."
      exit 1
    end

    # Drop and recreate the local database
    puts "Dropping and recreating the local database..."
    system("rails db:drop db:create")

    # Dump the remote database to a file
    puts "Dumping the remote database..."
    system("pg_dump --no-owner --no-acl -Fc #{database_url} -f tmp/latest.dump")

    # Restore the dump file to the local database
    puts "Restoring the database..."
    system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -U #{local_user} -d #{local_db} tmp/latest.dump")

    puts "Database pull complete!"
  end
end
