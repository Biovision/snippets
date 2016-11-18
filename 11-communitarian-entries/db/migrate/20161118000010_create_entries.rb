class CreateEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :entries do |t|
      t.timestamps
      t.integer :external_id
      t.references :community, foreign_key: true
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.boolean :deleted, null: false, default: false
      t.integer :privacy, limit: 2, null: false, default: Entry.privacies[:generally_accessible]
      t.integer :comments_count, null: false, default: 0
      t.integer :view_count, null: false, default: 0
      t.integer :rating, null: false, default: 0
      t.integer :upvote_count, null: false, default: 0
      t.integer :downvote_count, null: false, default: 0
      t.string :title
      t.string :slug
      t.text :body, null: false
    end

    execute "create index entries_created_month_idx on entries using btree (date_trunc('month', created_at));"
  end
end
