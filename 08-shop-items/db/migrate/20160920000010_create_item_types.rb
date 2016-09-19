class CreateItemTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :item_types do |t|
      t.string :name, null: false
      t.boolean :locked, null: false, default: false
      t.integer :items_count, null: false, default: 0
    end
  end
end
