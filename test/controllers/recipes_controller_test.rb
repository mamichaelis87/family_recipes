require "test_helper"

class RecipesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @owner = User.create!(email: "owner@example.com", password: "password123")
    @other = User.create!(email: "other@example.com", password: "password123")
    @recipe = @owner.recipes.create!(name: "Grandma's Soup", meal_type: "Dinner", servings: 4)
  end

  test "anyone can browse recipes" do
    get root_path
    assert_response :success
    get all_recipes_path
    assert_response :success
    get recipe_path(@recipe)
    assert_response :success
  end

  test "logged-out visitors cannot create recipes" do
    assert_no_difference "Recipe.count" do
      post recipes_path, params: { recipe: { name: "Spam" } }
    end
    assert_redirected_to new_user_session_path
  end

  test "logged-out visitors cannot update recipes or upload files" do
    patch recipe_path(@recipe), params: { recipe: { name: "Hacked", image: sample_image } }
    assert_redirected_to new_user_session_path
    @recipe.reload
    assert_equal "Grandma's Soup", @recipe.name
    assert_not @recipe.image.attached?
  end

  test "signed-in users can create a recipe with an image" do
    sign_in @other
    assert_difference "Recipe.count", 1 do
      post recipes_path, params: { recipe: { name: "New Stew", image: sample_image,
        ingredients_attributes: { "0" => { name: "salt", measurement_amount: "1", measurement_type: "tsp" } },
        steps_attributes: { "0" => { instructions: "stir" } } } }
    end
    recipe = Recipe.last
    assert_redirected_to recipe_path(recipe)
    assert recipe.image.attached?
    recipe.image.analyze
    assert_equal [1, 1], recipe.image.metadata.values_at("width", "height")
  end

  test "the owner cannot be set from the form" do
    sign_in @other
    post recipes_path, params: { recipe: { name: "Sneaky", user_id: @owner.id } }
    assert_equal @other, Recipe.last.user

    patch recipe_path(@recipe), params: { recipe: { name: "Renamed", user_id: @other.id } }
    assert_equal @owner, @recipe.reload.user
  end

  private

  def sample_image
    fixture_file_upload("pixel.png", "image/png")
  end
end
