class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.timestamps null: false
      t.inet :ip
      t.references :user, index: true, foreign_key: true
      t.boolean :deleted, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.integer :comments_count, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.string :image
      t.string :title
      t.text :lead
      t.text :body, null: false
      t.string :tags_cache, array: true, null: false, default: []
    end

    execute "create index posts_created_month_idx on posts using btree (date_trunc('month', created_at));"
  end
end
