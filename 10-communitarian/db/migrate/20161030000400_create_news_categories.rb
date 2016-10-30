class CreateNewsCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :news_categories do |t|
      t.integer :external_id
      t.integer :priority, limit: 2, null: false, default: 1
      t.integer :items_count, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.boolean :visible, null: false, default: true
      t.string :name, null: false
      t.string :slug, null: false
    end
  end
end
