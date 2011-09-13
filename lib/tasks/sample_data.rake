namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Doogma Mistamesh",
      :email => "doogma@mista.org",
      :password => "foolishbar",
      :password_confirmation => "foolishbar")
    99.times do |n|
      name = Faker::Name.name
      email = "doogma-#{n+1}@mista.org"
      password = "password"
      User.create!(:name => name,
        :email => email,
        :password => password,
        :password_confirmation => password)
    end
  end
end

