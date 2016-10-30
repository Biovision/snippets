class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.boolean :locked, null: false, default: false
      t.integer :post_categories_count, limit: 2, null: false, default: 0
      t.integer :news_categories_count, limit: 2, null: false, default: 0
      t.string :name, null: false
      t.string :slug, null: false
    end
  end
end
