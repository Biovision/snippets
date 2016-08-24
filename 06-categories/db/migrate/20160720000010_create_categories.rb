class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.timestamps null: false
      t.integer :parent_id, index: true
      t.integer :priority, null: false, default: 1
      t.integer :items_count, null: false, default: 0
      t.boolean :visible, null: false, default: true
      t.string :name, null: false, index: true
      t.string :slug
      t.string :parents_cache, null: false, default: ''
      t.integer :children_cache, array: true, null: false, default: []
    end
  end
end
