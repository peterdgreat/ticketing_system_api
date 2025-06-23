# frozen_string_literal: true

module Mutations
  class UpdateTicket < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: true
    type Types::TicketType

    def resolve(id:, status: nil)
      ticket = Ticket.find(id)
      authorize! :update, ticket
      ticket.status = status if status.present?
      if ticket.save
        ticket
      else
        raise GraphQL::ExecutionError.new("Failed to update ticket: #{ticket.errors.full_messages.join(', ')}")
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
