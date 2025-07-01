require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:customer) { create(:user, role: 'customer') }
  let(:agent) { create(:user, :agent) }
  let(:ticket) { create(:ticket, user: customer) }
  let(:comment) { build(:comment, ticket: ticket, user: customer) }

  subject { described_class }

  describe 'create?' do
    it 'allows agents to create comments' do
      expect(subject.new(agent, comment).create?).to be true
    end

    it 'allows customers to create comments if agent has commented' do
      create(:comment, ticket: ticket, user: agent)
      expect(subject.new(customer, comment).create?).to be true
    end

    it 'prevents customers from creating comments without agent comments' do
      expect(subject.new(customer, comment).create?).to be false
    end

    it 'prevents customers from commenting on others\' tickets' do
      other_customer = create(:user, role: 'customer')
      create(:comment, ticket: ticket, user: agent)
      expect(subject.new(other_customer, comment).create?).to be false
    end
  end

  describe 'Scope' do
    it 'returns all comments for agents' do
      create(:comment, ticket: ticket, user: customer)
      expect(Pundit.policy_scope(agent, Comment).count).to eq(1)
    end

    it 'returns only customer\'s ticket comments for customers' do
      other_ticket = create(:ticket)
      create(:comment, ticket: ticket, user: customer)
      create(:comment, ticket: other_ticket, user: customer)
      expect(Pundit.policy_scope(customer, Comment).count).to eq(1)
    end
  end
end
