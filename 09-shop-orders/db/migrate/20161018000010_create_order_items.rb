class CreateOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :order_items do |t|
      t.timestamps
      t.references :order, foreign_key: true, null: false
      t.references :item, foreign_key: true, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :price, null: false
    end
  end
end
