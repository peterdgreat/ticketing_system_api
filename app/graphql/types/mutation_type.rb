# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :close_ticket, mutation: Mutations::CloseTicket
    field :update_ticket, mutation: Mutations::UpdateTicket
    field :create_ticket, mutation: Mutations::CreateTicket
    field :ticket_create, mutation: Mutations::TicketCreate
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
