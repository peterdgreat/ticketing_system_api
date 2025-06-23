# frozen_string_literal: true

module Mutations
  class CloseTicket < BaseMutation
    argument :id, ID, required: true
    type Types::TicketType

    def resolve(id:)
      ticket = Ticket.find(id)
      authorize!(:close?, ticket)
      ticket.status = "closed"
      if ticket.save
      ticket
      else
        raise GraphQL::ExecutionError.new("Failed to close ticket: #{ticket.errors.full_messages.join(', ')}")
      end
    end

    private

    def authorize!(action, subject)
      unless Pundit.policy(context[:current_user], subject).send(action?)
        raise GraphQL::ExecutionError.new("Not authorized to #{action} #{subject.class.name}")
      end
    end
  end
end
