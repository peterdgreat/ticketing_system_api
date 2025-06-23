FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    role { 'customer' }

    trait :agent do
      role { 'agent' }
    end
  end
end
