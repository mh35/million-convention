class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :line_uid, null: false, unique: true
      t.text :access_token
      t.text :refresh_token
      t.datetime :access_token_expires_at
      t.string :display_name, null: false
      t.boolean :banned, null: false, default: false
      t.datetime :last_wrote_at
      t.datetime :last_thread_created_at

      t.timestamps
    end
  end
end
