namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Jakub", email: "jakub.niechcial@gmail.com", agreement: true, terms: true, city: "Poznań", tshirt: "M", password: "foobar", password_confirmation: "foobar", admin: true)
    make_users
    make_teams
    make_relationships
    make_competitions
    make_robots
  end
end

def make_users
  100.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    city = Faker::Name.name
    tshirt = 'M'
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 city:     city,
                 terms:    true,
                 agreement:true,
                 tshirt:   tshirt,
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

def make_competitions
  8.times do |n|
    name = Faker::Name.name
    Competition.create!(name: name)
  end
end

def make_relationships
  users = User.all
  teams = Team.all
  index = 0
  users.first(50).in_groups_of(5) do |group|
    group.each do |user|
      user.add_to_team(teams[index])
    end
    index = index + 1
  end
  index = 0
  users.last(50).in_groups_of(5) do |group|
    group.each do |user|
      user.request_to_team(teams[index])
    end
    index = index + 1
  end
end

def make_robots
  teams = Team.all
  competitions = Competition.all
  40.times do |i|
    name = Faker::Name.name
    Robot.create!(name: name, team: teams[i % 20], competition: competitions[i % 6])
  end
end