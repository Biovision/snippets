class CreateSites < ActiveRecord::Migration[5.0]
  def change
    create_table :sites do |t|
      t.timestamps
      t.boolean :active, null: false, default: true
      t.boolean :deleted, null: false, default: false
      t.boolean :has_regions, null: false, default: false
      t.string :name, null: false
      t.string :host, null: false
      t.string :image
      t.string :description
    end

    add_reference :users, :site, foreign_key: true, on_update: :cascade, on_delete: :nullify
  end
end
