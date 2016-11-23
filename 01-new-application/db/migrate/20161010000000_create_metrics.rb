class CreateMetrics < ActiveRecord::Migration[5.0]
  def change
    create_table :metrics do |t|
      t.boolean :incremental, null: false, default: false
      t.integer :value, null: false, default: 0
      t.integer :previous_value, null: false, default: 0
      t.string :name, null: false
      t.string :description
    end
  end
end
