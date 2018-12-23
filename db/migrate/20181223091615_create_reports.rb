class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.references :thread_response, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :reports, [:thread_response_id, :user_id], unique: true
  end
end
