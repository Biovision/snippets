class CreateIllustrations < ActiveRecord::Migration[5.0]
  def change
    create_table :illustrations do |t|
      t.timestamps
      t.references :user, foreign_key: true
      t.string :name
      t.string :image
    end
  end
end
