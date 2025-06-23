module Types
  class TicketType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: false
    field :status, String, null: false
    field :user, Types::UserType, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
