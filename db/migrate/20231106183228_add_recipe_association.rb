class AddRecipeAssociation < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :user, index: true
  end
end
