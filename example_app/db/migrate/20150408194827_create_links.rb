class CreateLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :links do |t|
      t.string :title, null: false
      t.string :url, null: false

      t.timestamps null: false
    end
  end
end
