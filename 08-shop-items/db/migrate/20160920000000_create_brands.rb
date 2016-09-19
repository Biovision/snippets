class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.timestamps
      t.boolean :deleted, null: false, default: false
      t.integer :priority, null: false, default: 1
      t.boolean :visible, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.integer :items_count, null: false, default: 0
      t.string :name, null: false
      t.string :slug
      t.string :image
      t.text :description
    end
  end
end
