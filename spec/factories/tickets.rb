FactoryBot.define do
  factory :ticket do
    user { nil }
    title { "MyString" }
    description { "MyString" }
    status { "MyString" }
  end
end
