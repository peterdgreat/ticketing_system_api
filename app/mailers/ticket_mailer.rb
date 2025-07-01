class TicketMailer < ApplicationMailer
  def daily_open_tickets_email(agent)
    @agent = agent
    @open_tickets = Ticket.where(status: "open").order(created_at: :asc)
    mail(to: @agent.email, subject: "Open Tickets Reminder")
  end
end
