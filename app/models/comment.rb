class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  validates :content, presence: true, length: { maximum: 5000 }
  validates :ticket_id, presence: true
  validates :user_id, presence: true
end
