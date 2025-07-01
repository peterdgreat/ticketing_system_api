FactoryBot.define do
  factory :attachment do
    association :user
    association :ticket
    after(:build) do |attachment|
      attachment.file.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
    end
  end
end
