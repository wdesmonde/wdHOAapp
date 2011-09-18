namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Doogma Mistamesh",
      :email => "doogma@mista.org",
      :password => "foolishbar",
      :password_confirmation => "foolishbar")
    admin.toggle!(:admin)
    User.create!(:name => "Sample Person",
      :email => "sperson@mista.org",
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
    50.times do
      User.all(:limit => 6).each do |user|
        user.tasks.create!(:content => Faker::Lorem.sentence(5),
          :priority => "High",
          :status => "New",
          :category => "Other",
          :due_date => 3.days.from_now)
      end
    end
  end
end

