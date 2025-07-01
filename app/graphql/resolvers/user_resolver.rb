module Resolvers
  class UserResolver < GraphQL::Schema::Resolver
    type [Types::UserType], null: false
    argument :id, ID, required: false
    def resolve(id: nil)
      scope = Pundit.policy_scope(context[:current_user], User)
      id ? scope.find(id) : scope.all
    end
  end
end
