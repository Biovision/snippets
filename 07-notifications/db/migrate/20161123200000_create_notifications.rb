class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.timestamps
      t.references :user, foreign_key: true, null: false
      t.integer :category, limit: 2, null: false
      t.integer :payload
      t.integer :repetition_count, null: false, default: 1
      t.boolean :read_by_user, null: false, default: false
    end
  end
end
