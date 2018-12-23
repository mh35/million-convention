class AddNonnullConstraintToIdols < ActiveRecord::Migration[5.1]
  def change
    change_column_null :idols, :name, false
    change_column_null :idols, :idol_num, false
    change_column_null :idols, :icon_url, false
  end
end
