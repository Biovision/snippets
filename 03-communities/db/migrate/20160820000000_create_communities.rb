class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, index: true, foreign_key: true
      t.inet :ip
      t.boolean :visible, null: false, default: true
      t.boolean :deleted, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.integer :category, limit: 2, null: false, default: Community.categories[:inclusive]
      t.integer :users_count, null: false, default: 0
      t.integer :posts_count, null: false, default: 0
      t.integer :offers_count, null: false, default: 0
      t.string :name, null: false
      t.string :slug
      t.string :image
      t.string :background
      t.text :description
    end
  end
end
