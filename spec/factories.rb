FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    tshirt "M"
    city "Poznan"
    password "foobarfoo"
    password_confirmation "foobarfoo"

    factory :admin do
      admin true
    end
  end

  factory :team do
  	sequence(:name)  { |n| "Team #{n}" }
  	description "Lorem ipsum"
  end

  factory :competition do
    sequence(:name)  { |n| "Competition #{n}" }
  end

  factory :robot do
    sequence(:name) { |n| "Robot #{n}" }
    team
    competition
  end
end
