module Resolvers
  class TicketResolver < GraphQL::Schema::Resolver
    type [Types::TicketType], null: false
    argument :status, String, required: false
    argument :user_id, ID, required: false

    def resolve(status: nil, user_id: nil)
      scope = Pundit.policy_scope(context[:current_user], Ticket)
      scope = scope.where(status: status) if status
      scope = scope.where(user_id: user_id) if user_id
      scope.all
    end
  end
end
