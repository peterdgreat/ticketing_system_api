require 'rails_helper'

RSpec.describe AttachmentPolicy, type: :policy do
  let (:customer) {create(:user, role: 'customer')}
  let (:agent) {create(:user, role: 'agent')}
  let (:ticket) {create(:ticket, user: customer)}
  let (:attachment) {create(:attachment, ticket: ticket, user: customer)}

  subject { described_class }
  describe 'create?' do
    it 'allows agents to create attachments' do
      expect(subject.new(agent, attachment).create?).to be true
    end

    it 'allows customers to create attachments on their tickets' do
      expect(subject.new(customer, attachment).create?).to be true
    end

    it 'prevents customers from creating attachments on others\' tickets' do
      other_customer = create(:user, role: 'customer')
      expect(subject.new(other_customer, attachment).create?).to be false
    end
  end

  describe 'Scope' do
    it 'returns all attachments for agents' do
      create(:attachment, ticket: ticket, user: customer)
      expect(Pundit.policy_scope(agent, Attachment).count).to eq(1)
    end

    it 'returns only customer\'s ticket attachments for customers' do
      other_ticket = create(:ticket)
      create(:attachment, ticket: ticket, user: customer)
      create(:attachment, ticket: other_ticket, user: customer)
      expect(Pundit.policy_scope(customer, Attachment).count).to eq(1)
    end
  end
end
