class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
      t.index [:ticket_id, :created_at]
    end
  end
end
