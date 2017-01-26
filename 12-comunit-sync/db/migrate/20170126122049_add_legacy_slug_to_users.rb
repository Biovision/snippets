class AddLegacySlugToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :legacy_slug, :boolean, null: false, default: false
    add_column :users, :comments_count, :integer, null: false, default: 0
    add_column :users, :posts_count, :integer, null: false, default: 0
  end
end
