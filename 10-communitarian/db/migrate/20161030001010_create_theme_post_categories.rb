class CreateThemePostCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :theme_post_categories do |t|
      t.references :theme, foreign_key: true, null: false
      t.references :post_category, foreign_key: true, null: false
    end
  end
end
