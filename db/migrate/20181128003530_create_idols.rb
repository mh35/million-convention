class CreateIdols < ActiveRecord::Migration[5.1]
  def change
    create_table :idols do |t|
      t.string :name
      t.integer :idol_num
      t.text :icon_url

      t.timestamps
    end
    add_index :idols, :name, unique: true
  end
end
