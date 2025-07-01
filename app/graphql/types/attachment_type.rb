# frozen_string_literal: true

module Types
  class AttachmentType < Types::BaseObject
    field :id, ID, null: false
    field :file_url, String, null: false
    field :file_type, String, null: false
    field :file_name, String, null: false
    field :file_size, Integer, null: false
    field :ticket, Types::TicketType, null: false
    field :user, Types::UserType, null: false
    field :created_at, String, null: false

    def file_url
      Rails.application.routes.url_helpers.rails_blob_url(object.blob, only_path: true)
    end

    def file_type
      object.blob.content_type
    end

    def file_name
      object.blob.filename.to_s
    end

    def file_size
      object.blob.byte_size
    end
  end
end
