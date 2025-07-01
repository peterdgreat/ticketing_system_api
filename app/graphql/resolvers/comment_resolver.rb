module Resolvers
  class CommentResolver < GraphQL::Schema::Resolver
    type [Types::CommentType], null: false
    argument :ticket_id, ID, required: false

    def resolve(ticket_id: nil)
      scope = Pundit.policy_scope(context[:current_user], Comment)
      scope = scope.where(ticket_id: ticket_id) if ticket_id
      scope.order(created_at: :asc)
    end
  end
end
