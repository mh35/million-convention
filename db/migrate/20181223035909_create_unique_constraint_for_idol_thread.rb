class CreateUniqueConstraintForIdolThread < ActiveRecord::Migration[5.1]
  def change
    add_index :idol_threads, [:idol_id, :thread_num], unique: true
  end
end
