class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.string :measurement_type
      t.float :measurement_amount
      t.belongs_to :recipe

      t.timestamps
    end
  end
end
