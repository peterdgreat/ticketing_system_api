class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.text :content, null: false

      t.timestamps
      t.index [:ticket_id, :created_at]
    end
  end
end
