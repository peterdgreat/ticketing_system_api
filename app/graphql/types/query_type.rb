# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false, resolver: Resolvers::UserResolver
    field :tickets, [Types::TicketType], null: false, resolver: Resolvers::TicketResolver
    field :ticket, Types::TicketType, null: false do
      argument :id, ID, required: true
    end

    def ticket(id:)
      ticket = Ticket.find(id)
      Pundit.authorize(context[:current_user], ticket, :show?)
      ticket
    end
  end
end
