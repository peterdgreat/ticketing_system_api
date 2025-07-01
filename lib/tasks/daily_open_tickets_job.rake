# lib/tasks/daily_open_tickets.rake
namespace :tickets do
  desc "Enqueue daily open tickets report"
  task daily_open_tickets: :environment do
    DailyOpenTicketsJob.perform_async
  end
end
