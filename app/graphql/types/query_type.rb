# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :users, [Types::UserType], null: false, resolver: Resolvers::UserResolver
    field :user,UserType, null: false
    field :tickets, [Types::TicketType], null: false, resolver: Resolvers::TicketResolver
    field :ticket, Types::TicketType, null: false do
      argument :id, ID, required: true
    end
    field :comments, [Types::CommentType], null: false, resolver: Resolvers::CommentResolver
    field :attachments, [Types::AttachmentType], null: false, resolver: Resolvers::AttachmentResolver

    def ticket(id:)
      ticket = Ticket.find(id)
      Pundit.authorize(context[:current_user], ticket, :show?)
      ticket
    end

    def user
      context[:current_user]
    end
  end
end
