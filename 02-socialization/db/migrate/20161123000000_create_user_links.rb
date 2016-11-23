class CreateUserLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_links do |t|
      t.timestamps
      t.references :agent, foreign_key: true
      t.inet :ip
      t.integer :follower_id, null: false
      t.integer :followee_id, null: false
      t.boolean :visible, null: false, default: true
    end
  end
end
