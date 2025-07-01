class CreateTickets < ActiveRecord::Migration[8.0]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.string :status, null: false, default: "open"

      t.timestamps
      t.index :status
    end
  end
end
