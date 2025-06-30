module Types
  class AuthPayloadType < Types::BaseObject
    field :user, Types::UserType, null: false
    field :token, String, null: false
  end
end
