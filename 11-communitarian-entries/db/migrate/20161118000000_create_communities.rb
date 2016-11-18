class CreateCommunities < ActiveRecord::Migration[5.0]
  def change
    create_table :communities do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.references :agent, foreign_key: true
      t.inet :ip
      t.boolean :inclusive, null: false, default: true
      t.boolean :deleted, null: false, default: false
      t.boolean :visible, null: false, default: true
      t.integer :entries_count, null: false, default: 0
      t.integer :members_count, null: false, default: 0
      t.string :name, null: false, index: true
      t.string :slug
      t.string :image
      t.text :description
    end
  end
end
