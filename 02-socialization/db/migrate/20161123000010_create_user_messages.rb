class CreateUserMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :user_messages do |t|
      t.timestamps
      t.references :agent, foreign_key: true
      t.inet :ip
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :read_by_receiver, null: false, default: false
      t.boolean :deleted_by_sender, null: false, default: false
      t.boolean :deleted_by_receiver, null: false, default: false
      t.text :body, null: false
    end
  end
end
