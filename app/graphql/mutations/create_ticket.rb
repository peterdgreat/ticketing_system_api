# frozen_string_literal: true

module Mutations
  class CreateTicket < BaseMutation
    argument :title, String, required: true
    argument :description, String, required: true
    type Types::TicketType


    def resolve(title:, description: nil)
      authorize! :create, Ticket
      ticket = Ticket.new(
        title: title,
        description: description,
        user: context[:current_user],
        status: "open"
      )
      if ticket.save
        ticket
      else
        raise GraphQL::ExecutionError.new("Invalid input: #{ticket.errors.full_messages.join(', ')}")
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
