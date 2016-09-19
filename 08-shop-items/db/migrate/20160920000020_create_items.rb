class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.timestamps
      t.references :brand, foreign_key: true
      t.references :category, foreign_key: true
      t.references :item_type, foreign_key: true
      t.boolean :visible, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.boolean :new_arrival, null: false, default: false
      t.boolean :sale, null: false, default: false
      t.boolean :exclusive, null: false, default: false
      t.integer :priority, null: false, default: 1
      t.integer :status, limit: 2, null: false, default: Item.statuses[:available]
      t.integer :price
      t.integer :old_price
      t.integer :comments_count, null: false, default: 0
      t.string :image
      t.string :name, null: false
      t.string :slug
      t.string :article
      t.text :description
    end
  end
end
