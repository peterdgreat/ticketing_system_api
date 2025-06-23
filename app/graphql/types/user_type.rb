module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :role, Sring, null: false
    field :created_at, String, null: false
  end
end
