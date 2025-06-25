module Resolvers
  class AttachmentResolver < GraphQL::Schema::Resolver
    type [Types::AttachmentType], null: false
    argument :ticket_id, ID, required: false

    def resolve(ticket_id: nil)
      scope = Pundit.policy_scope!(context[:current_user], Attachment)
      scope = scope.where(ticket_id: ticket_id) if ticket_id
      scope.order(created_at: :desc)
    end
  end

end
