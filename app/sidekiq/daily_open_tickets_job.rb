class DailyOpenTicketsJob
  include Sidekiq::Job

  def perform
    Rails.logger.info("Daily Open Tickets Job started at #{Time.current}" )
    User.where(role: "agent").each do |agent|
      Rails.logger.info("Sending daily reminder to agent #{agent.email}")
      TicketMailer.daily_open_tickets_email(agent).deliver_now
    end
    Rails.logger.info "DailyOpenTicketsJob completed at #{Time.current}"
  end
end
