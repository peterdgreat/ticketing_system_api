# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :close_ticket, mutation: Mutations::CloseTicket
    field :update_ticket, mutation: Mutations::UpdateTicket
    field :create_ticket, mutation: Mutations::CreateTicket
  end
end
