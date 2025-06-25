require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'validation' do
    it {should validate_presence_of :file}
  end
  describe 'associations' do
    it {should belong_to :user}
    it {should belong_to :ticket}
  end
  describe 'file type and size' do
    let (:attachment) {build(:attachment)}
    it 'allows JPEG, PNG, and PDF' do
      attachment.file.attach(io: StringIO.new('test'), filename: 'test.jpg', content_type: 'image/jpeg')
      expect(attachment).to be_valid
    end
    it 'rejects invalid file types' do
      attachment.file.attach(io: StringIO.new('test'), filename: 'test.exe', content_type: 'application/octet-stream')
      expect(attachment).not_to be_valid
      expect(attachment.errors[:file]).to include('must be a JPEG, PNG, or PDF')
    end
    it 'rejects files over 5MB' do
      allow(attachment.file).to receive(:byte_size).and_return(6.megabytes)
      expect(attachment).not_to be_valid
      expect(attachment.errors[:file]).to include('must be less than 5MB')
    end
  end
end
