class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end
  end
end
