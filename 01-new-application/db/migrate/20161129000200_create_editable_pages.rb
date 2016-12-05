class CreateEditablePages < ActiveRecord::Migration[5.0]
  def change
    create_table :editable_pages do |t|
      t.timestamps
      t.string :name, null: false
      t.string :slug, null: false
      t.string :title, null: false, default: ''
      t.string :keywords, null: false, default: ''
      t.text :description, null: false, default: ''
      t.text :body, null: false, default: ''
    end
  end
end
