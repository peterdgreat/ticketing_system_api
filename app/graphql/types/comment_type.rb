module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :content, String, null: false
    field :ticket, Types::TicketType, null: false
    field :user, Types::UserType, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
