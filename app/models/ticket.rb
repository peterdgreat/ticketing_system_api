class Ticket < ApplicationRecord
  belongs_to :user
  enum :status, {
    open: "open",
    pending: "pending",
    resolved: "resolved",
    closed: "closed"
  }, default: :open

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :user_id, presence: true
end
