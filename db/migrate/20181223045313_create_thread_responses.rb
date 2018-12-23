class CreateThreadResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :thread_responses do |t|
      t.references :idol_thread, foreign_key: true
      t.references :user, foreign_key: true
      t.string :ip_addr
      t.integer :res_no, null: false
      t.text :content, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
    add_index :thread_responses, [:idol_thread_id, :res_no], unique: true
  end
end
