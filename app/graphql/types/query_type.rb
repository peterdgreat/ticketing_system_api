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
    field :attachments, [Types::AttachmentType], null: false, resolver: Resolvers::AttachmentResolver do
      argument :ticket_id, ID, required: true
    end

    def ticket(id:)
      ticket = Ticket.find(id)
      Pundit.authorize(context[:current_user], ticket, :show?)
      ticket
    end

    def user
      context[:current_user]
    end

    def attachments(ticket_id:)
      ticket = Ticket.find(ticket_id)
      Pundit.authorize(context[:current_user], ticket, :show?)
      Attachment.where(ticket_id: ticket_id).order(created_at: :asc).all
    end
  end
end
