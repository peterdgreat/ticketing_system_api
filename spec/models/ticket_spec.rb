require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(255) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:user_id) }
  end
  describe 'associations' do
    it { should belong_to(:user) }
  end
  describe 'enums' do
    it 'has open, pending, and closed statuses' do
      expect(Ticket.statuses).to eq({ 'open' => 'open', 'pending' => 'pending', 'resolved' => 'resolved', 'closed' => 'closed' })
    end
  end
end
