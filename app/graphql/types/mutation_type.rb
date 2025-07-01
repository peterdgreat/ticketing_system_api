# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :close_ticket, mutation: Mutations::CloseTicket
    field :update_ticket, mutation: Mutations::UpdateTicket
    field :create_ticket, mutation: Mutations::CreateTicket
    field :add_comment, mutation: Mutations::AddComment
    field :upload_attachment, mutation: Mutations::UploadAttachment
    field :sign_up, mutation: Mutations::SignUp
    field :login, mutation: Mutations::Login
  end
end
