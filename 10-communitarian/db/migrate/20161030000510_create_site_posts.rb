class CreateSitePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :site_posts do |t|
      t.references :post, foreign_key: true, null: false
      t.references :post_category, foreign_key: true, null: false
    end
  end
end
