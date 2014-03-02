namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_teams
    make_relationships
  end
end

def make_users
  100.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_teams
  20.times do |n|
    name = Faker::Name.name
    description = Faker::Lorem.sentence(5)
    Team.create!(name: name, description: description)
  end
end

def make_relationships
  users = User.all
  teams = Team.all
  index = 0
  users.in_groups_of(5) do |group|
    group.each do |user|
      user.request_to_team(teams[index])
    end
    index = index + 1
  end
end