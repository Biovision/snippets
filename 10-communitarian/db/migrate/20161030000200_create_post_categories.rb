class CreatePostCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :post_categories do |t|
      t.integer :external_id
      t.integer :parent_id, index: true
      t.integer :priority, null: false, default: 1
      t.integer :items_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.boolean :visible, null: false, default: true
      t.string :name, null: false
      t.string :slug, null: false
      t.string :parents_cache, null: false, default: ''
      t.integer :children_cache, array: true, null: false, default: []
    end
  end
end
