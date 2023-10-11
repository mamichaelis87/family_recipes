class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :type
      t.string :culture
      t.float :prep_hours
      t.float :prep_minutes
      t.float :servings

      t.timestamps
    end
  end
end
