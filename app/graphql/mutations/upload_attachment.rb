module Mutations
  class UploadAttachment < GraphQL::Schema::Mutation
    argument :ticket_id, ID, required: true
    argument :file, ApolloUploadServer::Upload, required: true
    type Types::AttachmentType

    def resolve(ticket_id:, file:)
      unless context[:current_user]
        raise GraphQL::ExecutionError, 'Authentication required'
      end
      unless file
        raise GraphQL::ExecutionError, 'File is required'
      end
      ticket = Ticket.find(ticket_id)
      attachment = ticket.attachments.build(user: context[:current_user])
      authorize! :create, attachment

      attachable = {
        io: file.tempfile,
        filename: file.original_filename,
        content_type: file.content_type
      }
      attachment.file.attach(attachable)

      if attachment.save
        attachment
      else
        raise GraphQL::ExecutionError, attachment.errors.full_messages.join(', ')
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
