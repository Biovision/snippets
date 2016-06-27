class CreateComments < ActiveRecord::Migration
  def change
    create_table :'05-comments' do |t|
      t.timestamps null: false
      t.references :user, index: true, foreign_key: true
      t.inet :ip
      t.boolean :deleted, null: false, default: false
      t.integer :commentable_id, null: false
      t.string :commentable_type, null: false
      t.text :body, null: false
    end

    add_index :'05-comments', [:commentable_id, :commentable_type]
  end
end
