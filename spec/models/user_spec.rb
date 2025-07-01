require 'rails_helper'
RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:role) }
    it { should validate_length_of(:password).is_at_least(8).on(:create) }
  end
  describe 'callbacks' do
    it 'downcases email before saving' do
      user = create(:user, email: 'TEST@EXAMPLE.COM')
      expect(user.email).to eq('test@example.com')
    end
  end

  describe 'enums' do
    it 'has customer and agent roles' do
      expect(User.roles).to include({ customer: 'customer', agent:  'agent' })
    end
  end
end
