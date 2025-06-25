class Attachment < ApplicationRecord
  belongs_to :user
  belongs_to :ticket
  has_one_attached :file
  validates :file, presence: true
  validate :file_type_and_size

  private

  def file_type_and_size
    return unless file.attached?
    allowed_types = %w[image/jpeg image/png application/pdf]
    unless allowed_types.include?(file.content_type)
      errors.add(:file, "must be a JPEG, PNG, or PDF")
    end
    if file.byte_size > 5.megabytes
      errors.add(:file, "must be less than 5MB")
    end
  end
end
