class Ticket < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :attachments, dependent: :destroy
  enum :status, {
    open: "open",
    pending: "pending",
    resolved: "resolved",
    closed: "closed"
  }, default: :open

  validates :title, presence: true, length: { maximum: 255 }
  validates :status, presence: true
  validates :user_id, presence: true

  def can_comment?(user)
       false unless user
       user.agent? || (user.customer? && user.id == self.user_id && comments.any?{|c|c.user.agent?} )
  end
end
