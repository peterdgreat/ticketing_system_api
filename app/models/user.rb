class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :jwt_authenticatable,
  jwt_revocation_strategy: Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :tickets, dependent: :destroy
  enum :role,
   {
    customer: "customer", agent: "agent"
  }, default: :customer
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 8 }, on: :create
  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
