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
  describe '#can_comment?' do
  let(:customer) { create(:user, role: 'customer') }
  let(:agent) { create(:user, :agent) }
  let(:ticket) { create(:ticket, user: customer) }

  it 'allows agents to comment' do
    expect(ticket.can_comment?(agent)).to be true
  end

  it 'allows customers to comment if agent has commented' do
    create(:comment, ticket: ticket, user: agent)
    expect(ticket.can_comment?(customer)).to be true
  end

  it 'prevents customers from commenting without agent comments' do
    expect(ticket.can_comment?(customer)).to be false
  end
end
end
