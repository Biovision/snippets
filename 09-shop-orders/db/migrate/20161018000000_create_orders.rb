class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.integer :items_count, null: false, default: 0
      t.integer :price, null: false, default: 0
      t.integer :status, null: false, default: Order.statuses[:incomplete]
      t.string :slug
      t.string :name
      t.string :phone
      t.string :email
      t.string :address
      t.text :comment
    end
  end
end
