module Mutations
  class AddComment < GraphQL::Schema::Mutation
    argument :ticket_id, ID, required: true
    argument :content, String, required: true
    type Types::CommentType

    def resolve(ticket_id:, content:)
      ticket = Ticket.find(ticket_id)
      comment = ticket.comments.build(content: content, user: context[:current_user])
      authorize! :create, comment
      if comment.save
        comment
      else
        GraphQL::ExecutionError.new("Invalid input: #{comment.errors.full_messages.join(', ')}")
      end
    end
    private

    def authorize!(action, subject)
      unless Pundit.policy(context[:current_user], subject).public_send("#{action}?")
        raise GraphQL::ExecutionError, 'Not authorized'
      end
    end

  end
end
