class CreateIdolThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :idol_threads do |t|
      t.references :idol, foreign_key: true
      t.string :name, null: false
      t.integer :thread_num, null: false

      t.timestamps
    end
  end
end
