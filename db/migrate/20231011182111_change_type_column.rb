class ChangeTypeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :recipes, :type, :meal_type
  end
end
