class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.boolean :locked, null: false, default: false
      t.integer :users_count, null: false, default: 0
      t.integer :news_count, null: false, default: 0
      t.string :slug, null: false
      t.string :name, null: false
      t.string :image
    end

    # add_reference :users, :region, foreign_key: true
  end
end
