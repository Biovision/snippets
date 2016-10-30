class CreateNews < ActiveRecord::Migration[5.0]
  def change
    create_table :news do |t|
      t.timestamps
      t.integer :external_id
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true, index: true
      t.inet :ip
      t.integer :post_type, limit: 2, null: false, default: News.post_types[:news]
      t.boolean :visible, null: false, default: true
      t.boolean :locked, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.integer :comments_count, null: false, default: 0
      t.integer :view_count, null: false, default: 0
      t.string :title, null: false
      t.string :slug, null: false
      t.string :image
      t.string :source
      t.text :lead
      t.text :body, null: false
    end

    execute "create index news_created_month_idx on news using btree (date_trunc('month', created_at));"
  end
end
