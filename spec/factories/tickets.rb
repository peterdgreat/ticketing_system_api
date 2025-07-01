FactoryBot.define do
  factory :ticket do
    association :user, factory: :user
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { "open" }
  end
end
