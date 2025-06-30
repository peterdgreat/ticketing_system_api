# frozen_string_literal: true

module Mutations
  class CreateTicket < GraphQL::Schema::Mutation
    argument :title, String, required: true
    argument :description, String, required: true
    argument :attachment_files, [ApolloUploadServer::Upload], required: false
    type Types::TicketType


    def resolve(title:, description: nil, attachment_files: nil)
      authorize! :create, Ticket
      ticket = Ticket.new(
        title: title,
        description: description,
        user: context[:current_user],
        status: "open"
      )
      if ticket.save
        if attachment_files.present?
          attachment_files.each do|file|
            ticket.attachments.attach(
              io: file,
              filename: file.original_filename,
              content_type: file.content_type
            )
          end
        end
        ticket
      else
        raise GraphQL::ExecutionError.new("Invalid input: #{ticket.errors.full_messages.join(', ')}")
      end
    end

    private

    def authorize!(action, subject)
      unless Pundit.policy(context[:current_user], subject).send("#{action}?")
        raise GraphQL::ExecutionError.new("Not authorized to #{action} #{subject.class.name}")
      end
    end
  end
end
