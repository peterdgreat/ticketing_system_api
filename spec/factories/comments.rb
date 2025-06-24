FactoryBot.define do
  factory :comment do
    association :ticket
    association :user
    content { Faker::Lorem.paragraph }
  end
end
