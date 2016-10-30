class CreateSiteNews < ActiveRecord::Migration[5.0]
  def change
    create_table :site_news do |t|
      t.references :news, foreign_key: true, null: false
      t.references :news_category, foreign_key: true, null: false
    end
  end
end
