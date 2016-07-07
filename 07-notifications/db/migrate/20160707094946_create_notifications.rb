class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :category, limit: 2, null: false
      t.integer :payload
      t.boolean :was_read, null: false, default: false
    end
  end
end
