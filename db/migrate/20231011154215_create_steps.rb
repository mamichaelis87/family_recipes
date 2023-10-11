class CreateSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.integer :step_number
      t.string :instructions
      t.belongs_to :recipe

      t.timestamps
    end
  end
end
